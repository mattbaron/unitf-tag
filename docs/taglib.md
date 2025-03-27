# taglib Notes
Notes on `taglib` and `taglib-ruby` issues

**GitHub**
- https://github.com/taglib/taglib
- https://github.com/robinst/taglib-ruby

## Custom TagLib 1.13.1 Build on MacOS
```
curl -O https://taglib.org/releases/taglib-1.13.1.tar.gz
tar xvf taglib-1.13.1.tar.gz
cd taglib-1.13.1
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/taglib1 -DCMAKE_BUILD_TYPE=Release .
make
sudo make install
```

```
TAGLIB_DIR=/usr/local/taglib1 gem install taglib-ruby --version '< 2'
```

## Custom Build on Linux
```
git clone https://github.com/taglib/taglib.git
cd taglib/
git submodule update --init
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/taglib -DCMAKE_BUILD_TYPE=Release .
make
make install
```

```
TAGLIB_DIR=/usr/local/taglib gem install taglib-ruby --version '>= 2'
```

### Taglib error w/ taglib 2.0.2
```
root@homer:/nas/music2/WFMU# gem install /tmp/unitf-tag-0.1.27.gem
Successfully installed unitf-tag-0.1.27
Parsing documentation for unitf-tag-0.1.27
Installing ri documentation for unitf-tag-0.1.27
Done installing documentation for unitf-tag after 0 seconds
1 gem installed
root@homer:/nas/music2/WFMU# tag
<internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:136:in `require': /usr/local/lib64/gems/ruby/taglib-ruby-2.0.0/taglib_base.so: undefined symbol: _ZN6TagLib4File11removeBlockElm - /usr/local/lib64/gems/ruby/taglib-ruby-2.0.0/taglib_base.so (LoadError)
	from <internal:/usr/share/rubygems/rubygems/core_ext/kernel_require.rb>:136:in `require'
```
