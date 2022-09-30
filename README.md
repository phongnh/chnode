# chnode

Like chruby but for Node.js

# Usage

## Install

Clone project

```
git clone https://github.com/phongnh/chnode.git ~/.chnode
```

## Z shell

Add the following lines to your `~/.zshrc`

```
source ~/.chnode/chnode.sh
source ~/.chnode/auto.sh
```

## Bash shell

Add the following lines to your `~/.bashrc`

```
source ~/.chnode/chnode.sh
source ~/.chnode/auto.sh
```

## Fish shell

Please check the repo [chnode-fish](https://github.com/phongnh/chnode-fish).

## Install NodeJS versions

You can use [node-build](https://github.com/nodenv/node-build) to install Node.js

```
node-build 16.10.0 ~/.nodes/16.10.0
```

# Credits

All credits should go to the original project https://github.com/postmodern/chruby.
