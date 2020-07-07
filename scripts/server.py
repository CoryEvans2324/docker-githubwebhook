#!/usr/bin/python3

from http.server import HTTPServer
from http.server import BaseHTTPRequestHandler

import os
import json
import hashlib
import hmac
from subprocess import Popen

HOOK_SECRET_KEY = os.getenv('HOOK_SECRET_KEY') or 'THIS IS A SECRET'
HOOK_SECRET_KEY = HOOK_SECRET_KEY.encode()


class RequestHandler(BaseHTTPRequestHandler):

    def _validate_signature(self, data):
        github_hash = self.headers.get('X-Hub-Signature', None)
        if not github_hash:
            return False

        algo, github_hash = github_hash.split('=')[:2]

        if algo != 'sha1':
            return False

        mac = hmac.new(HOOK_SECRET_KEY, msg=data, digestmod=hashlib.sha1)
        return hmac.compare_digest(mac.hexdigest(), github_hash)


    def _callback(self):
        try:
            Popen('pull.sh', env=dict(os.environ))
        except OSError:
            return False

        return True


    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', '0'))
        if content_length == 0:
            return self._close(400, 'No payload found')

        event_type = self.headers.get('X-Github-Event', None)
        if not event_type:
            return self._close(400, 'No event found')


        fdata = self.rfile.read(content_length)

        if not self._validate_signature(fdata):
            return self._close(401, 'bad or no hash.')

        try:
            data = json.loads(fdata.decode())
        except json.decoder.JSONDecodeError:
            return self._close(400, 'JSON decode error')


        if 'ref' in data and data['ref'].split('/')[-1] != 'master':
            return self._close(200, 'Not master branch.')


        if not self._callback():
            return self._close(500, 'callback failed')

        return self._close(200, 'authed')


    def _close(self, status_code, message=None):
        self.send_response(status_code)
        self.end_headers()

        if message:
            self.wfile.write((message + '\n').encode())

        return


def main(addr, port):
    httpd = HTTPServer((addr, port), RequestHandler)
    httpd.serve_forever()

if __name__ == "__main__":
    main('0.0.0.0', 80)
