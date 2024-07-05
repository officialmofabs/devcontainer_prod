# script to setup a prod server with devcontainer features.

# setting up the prod machine

## scaffold the devcontainer 
`source <(curl -s https://gist.githubusercontent.com/luutuankiet/5c88f9640c596ec5a23a96337304756b/raw/boilerplate_devcontainer.sh)`
- change .devcontainer dir to .devcontainer_prod, and update the path to `"postCreateCommand": "bash -i .devcontainer_prod/postCreateCommand.sh"`
- make changes for features i.e.
```json
	"features": {
		"ghcr.io/devcontainers/features/node:1": {
			"nodeGypDependencies": true,
			"installYarnUsingApt": true,
			"version": "lts",
			"nvmVersion": "latest"
		},
		"ghcr.io/devcontainers/features/sshd:1": {
			"version": "latest"
		}
    }
```
- change the name and add some ports to forward
```json
	"runArgs": [
		"--name",
		"PROD_gtd_ETL",
		"-p=60000:60000", // ssh
		"-p=60001:60001" // dagster
	]
```
- cd to the dir & run devcontainer : 
 `devcontainer up --config .devcontainer_prod/devcontainer.json --workspace-folder .`
(add `--remove-existing-container` if you want to rebuild)
- clone the repo and unpack to the workspace

## ssh setup
(sshd [feature](https://github.com/devcontainers/features/tree/main/src/sshd) guide)
- `passwd` and change the root password
- `vim /etc/ssh/sshd.config` and update the port value to the desired port e.g. 60000
- `/etc/init.d/ssh restart` to restart the ssh server
- `ssh -p 60000 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o GlobalKnownHostsFile=/dev/null root@<machine_ip>`