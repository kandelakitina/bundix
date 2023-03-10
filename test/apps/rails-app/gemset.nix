{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ypdmpdn20hxp5vwxz3zc04r5xcwqc25qszdlg41h8ghdqbllwmw";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "2.8.1";
  };
  apparition = {
    dependencies = ["capybara" "websocket-driver"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "ca86be4d54af835d531dbcd2b86e7b2c77f85f34";
      sha256 = "00kkn98517cm6zc78r5i211wwjpixq5c4zzbmnd4rw46sdw9sm86";
      target = "ruby";
      type = "git";
      url = "https://github.com/twalpole/apparition.git";
    };
    targets = [];
    version = "0.6.0";
  };
  capybara = {
    dependencies = ["addressable" "matrix" "mini_mime" "nokogiri" "rack" "rack-test" "regexp_parser" "xpath"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "123198zk2ak8mziwa5jc3ckgpmsg08zn064n3aywnqm9s1bwjv3v";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "3.38.0";
  };
  matrix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1h2cgkpzkh3dd0flnnwfq6f3nl2b1zff9lvqz8xs853ssv5kq23i";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "0.4.2";
  };
  mini_mime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0lbim375gw2dk6383qirz13hgdmxlan0vc5da2l072j3qw6fqjm5";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "1.1.2";
  };
  nokogiri = {
    dependencies = ["racc"];
    groups = ["default"];
    platforms = [];
    source = null;
    targets = [{
      remotes = ["https://rubygems.org"];
      sha256 = "0cbnqn4g60vyhmymy2wdjqd1jrg35qy54irqbir9gdgc2k84qh41";
      target = "arm64-darwin";
      targetCPU = "arm64";
      targetOS = "darwin";
      type = "gem";
    } {
      remotes = ["https://rubygems.org"];
      sha256 = "0xp427axb5h5rbdgmcviqdc6wk62q3qpbmw23x06xb6xyghhar5w";
      target = "x86_64-linux";
      targetCPU = "x86_64";
      targetOS = "linux";
      type = "gem";
    }];
    version = "1.14.2";
  };
  phony_gem = {
    groups = ["default"];
    platforms = [];
    source = {
      path = "lib/phony_gem";
      type = "path";
    };
    targets = [];
    version = "0.1.0";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hz0bx2qs2pwb0bwazzsah03ilpf3aai8b7lk7s35jsfzwbkjq35";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "5.0.1";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09jgz6r0f7v84a7jz9an85q8vvmp743dqcsdm3z9c8rqcqv6pljq";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "1.6.2";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1d6v3zwv77h32d0j5f7n3m23z51i0m0h483y8zlwi0qd0f3zkqzm";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "3.0.4.2";
  };
  rack-test = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rjl709krgf499dhjdapg580l2qaj9d91pwzk8ck8fpnazlx1bdd";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "2.0.2";
  };
  regexp_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0d6241adx6drsfzz74nx1ld3394nm6fjpv3ammzr0g659krvgf7q";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "2.7.0";
  };
  sqlite3 = {
    groups = ["default"];
    platforms = [];
    source = null;
    targets = [{
      remotes = ["https://rubygems.org"];
      sha256 = "0ncgzhyk8gfr83mb3gqd0s8j3jxhcgpa05vk693vaa7d45cfwvxk";
      target = "x86_64-linux";
      targetCPU = "x86_64";
      targetOS = "linux";
      type = "gem";
    } {
      remotes = ["https://rubygems.org"];
      sha256 = "0yj7sy9i5rrl002qigpl3psqfvqjlksa0yda4879cc5xvafv2xx8";
      target = "arm64-darwin";
      targetCPU = "arm64";
      targetOS = "darwin";
      type = "gem";
    }];
    version = "1.6.1";
  };
  websocket-driver = {
    dependencies = ["websocket-extensions"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a3bwxd9v3ghrxzjc4vxmf4xa18c6m4xqy5wb0yk5c6b9psc7052";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "0.7.5";
  };
  websocket-extensions = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hc2g9qps8lmhibl5baa91b4qx8wqw872rgwagml78ydj8qacsqw";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "0.1.5";
  };
  xpath = {
    dependencies = ["nokogiri"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0bh8lk9hvlpn7vmi6h4hkcwjzvs2y0cmkk3yjjdr8fxvj6fsgzbd";
      target = "ruby";
      type = "gem";
    };
    targets = [];
    version = "3.2.0";
  };
}