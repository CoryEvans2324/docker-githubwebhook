# docker-githubwebhook

I would run this behind a reverse proxy like nginx.

## Usage

Create a deploy key and add the public key to the deploy keys of the repo.

```bash
ssh-keygen -t ed25519 -f ssh/id_ed25519 -q -N ""
mkdir -p code
```

### Docker

```docker
docker create \
    --name=githubwebhook \
    -e PUID=1000 \
    -e PGID=1000 \
    -e TZ=Pacific/Auckland \
    -e HOOK_SECRET_KEY=secret \
    -e GIT_REPO=git@github.com:user/repo_name.git \
    -e GIT_BRANCH=master \
    -p 80:80 \
    -v $(pwd)/ssh:/tmp/.ssh \
    -v $(pwd)/code:/code \
    coryevans2324/githubwebhook

docker start githubwebhook
```


### Parameters
| Parameter | Function
| :----: | --- |
| -e PUID=1000 | User ID to `chown /code` to |
| -e PGID=1000 | Group ID to `chown /code` to |
| -e TZ=Pacific/Auckland | TimeZone |
| -e HOOK_SECRET_KEY | gtihub hook secret to secure webhook |
| -e GIT_REPO | repo to clone |
| -e GIT_BRANCH | branch to pull from, defaults to master |
| -p 80 | http port |
| -v /tmp/.ssh | volume for ssh keys & config |
| -v /code | volume that exposes the git repo to the host |
