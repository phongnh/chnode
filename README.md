# chnode-fish

Like chruby but for Node.js and Fish shell.

# Usage

Clone project

```
git clone https://github.com/phongnh/chnode-fish.git ~/.chnode-fish
```


Add the following lines to your `~/.config/fish/config.fish`

```
source ~/.chnode-fish/chnode.fish
source ~/.chnode-fish/auto.fish
```

You can to use [node-build](https://github.com/nodenv/node-build) to install Node.js

```
node-build 16.10.0 ~/.nodes/16.10.0
```

# Credits

All credits should go to the original project https://github.com/postmodern/chruby.
