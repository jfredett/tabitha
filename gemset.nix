{
  async = {
    dependencies = ["console" "fiber-annotation" "io-event"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17aq671gzxsv1irmqjcj7p7vm4jpmy74hw2x1f3r7i71xnfgcq2x";
      type = "gem";
    };
    version = "2.21.1";
  };
  attr_extras = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "09y83ygjsk4rva8bn9mfb4whjh7q2sl4093n6wnvm1axvnlwjvyr";
      type = "gem";
    };
    version = "7.1.0";
  };
  coderay = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0jvxqxzply1lwp7ysn94zjhh57vc14mcshw1ygw14ib8lhc00lyw";
      type = "gem";
    };
    version = "1.1.3";
  };
  console = {
    dependencies = ["fiber-annotation" "fiber-local" "json"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1mkwwz5ry6hbn328fb3myr86zsc6lg0f7w1dlbfmjw043ddbgndg";
      type = "gem";
    };
    version = "1.29.2";
  };
  diff-lcs = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znxccz83m4xgpd239nyqxlifdb7m8rlfayk6s259186nkgj6ci7";
      type = "gem";
    };
    version = "1.5.1";
  };
  docile = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "07pj4z3h8wk4fgdn6s62vw1lwvhj0ac0x10vfbdkr9xzk7krn5cn";
      type = "gem";
    };
    version = "1.4.1";
  };
  fiber-annotation = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00vcmynyvhny8n4p799rrhcx0m033hivy0s1gn30ix8rs7qsvgvs";
      type = "gem";
    };
    version = "0.2.0";
  };
  fiber-local = {
    dependencies = ["fiber-storage"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01lz929qf3xa90vra1ai1kh059kf2c8xarfy6xbv1f8g457zk1f8";
      type = "gem";
    };
    version = "1.1.0";
  };
  fiber-storage = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0zxblmxwdpj3587wji5325y53gjdcmzxzm6126dyg58b3qzk42mq";
      type = "gem";
    };
    version = "1.0.0";
  };
  io-console = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "18pgvl7lfjpichdfh1g50rpz0zpaqrpr52ybn9liv1v9pjn9ysnd";
      type = "gem";
    };
    version = "0.8.0";
  };
  io-event = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1s2ja3x17ffakc5iq56js0bp0wrqdvyhcbz5a9m3nnzks06wkywr";
      type = "gem";
    };
    version = "1.7.5";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "048danb0x10mpch6mf88mky35zjn6wk4hpbqq68ssbq58i3fzgfj";
      type = "gem";
    };
    version = "2.9.1";
  };
  method_source = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1igmc3sq9ay90f8xjvfnswd1dybj1s3fi0dwd53inwsvqk4h24qq";
      type = "gem";
    };
    version = "1.1.0";
  };
  oppen = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1gh5ya2fl21lgp3s601h63dz63g5wgqgmz6vygzjp5jrnmnzi0g6";
      type = "gem";
    };
    version = "0.9.8";
  };
  optimist = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "073pk2rhyjq2vhdiz3xh2s884r15cvprw1yfjs7h9bmwdf1f9j81";
      type = "gem";
    };
    version = "3.2.0";
  };
  patience_diff = {
    dependencies = ["optimist"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0b42yr1yyph9knibnf7v896wzfqf9mmzlw00m3sgy0mghr20k4pl";
      type = "gem";
    };
    version = "1.2.0";
  };
  pry = {
    dependencies = ["coderay" "method_source"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0ssv704qg75mwlyagdfr9xxbzn1ziyqgzm0x474jkynk8234pm8j";
      type = "gem";
    };
    version = "0.15.2";
  };
  rake = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  reline = {
    dependencies = ["io-console"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lirwlw59apc8m1wjk85y2xidiv0fkxjn6f7p84yqmmyvish6qjp";
      type = "gem";
    };
    version = "0.6.0";
  };
  rexml = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1ch4k2y80r4glr579kxliqnxld2qa91ydq8fiqam38bzpbps3gpg";
      type = "gem";
    };
    version = "3.4.0";
  };
  rspec = {
    dependencies = ["rspec-core" "rspec-expectations" "rspec-mocks"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "14xrp8vq6i9zx37vh0yp4h9m0anx9paw200l1r5ad9fmq559346l";
      type = "gem";
    };
    version = "3.13.0";
  };
  rspec-core = {
    dependencies = ["rspec-support"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "001kazj244cb6fbkmh7ap74csbr78717qaskqzqpir1q8xpdmywl";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-expectations = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0n3cyrhsa75x5wwvskrrqk56jbjgdi2q1zx0irllf0chkgsmlsqf";
      type = "gem";
    };
    version = "3.13.3";
  };
  rspec-its = {
    dependencies = ["rspec-core" "rspec-expectations"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1pv0a8pvixgrwsi6j4nlpyn9m0jw9zn92dakjdg87wj9h71qp3m8";
      type = "gem";
    };
    version = "2.0.0";
  };
  rspec-mocks = {
    dependencies = ["diff-lcs" "rspec-support"];
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1vxxkb2sf2b36d8ca2nq84kjf85fz4x7wqcvb8r6a5hfxxfk69r3";
      type = "gem";
    };
    version = "3.13.2";
  };
  rspec-spies = {
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04ypkhsx1la23sv4lg8dxr4qjsjm456valnrhsqav07wc33jc0w2";
      type = "gem";
    };
    version = "1.2.9";
  };
  rspec-support = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1v6v6xvxcpkrrsrv7v1xgf7sl0d71vcfz1cnrjflpf6r7x3a58yf";
      type = "gem";
    };
    version = "3.13.2";
  };
  ruby_tree_sitter = {
    dependencies = ["oppen" "sorbet-runtime" "zeitwerk"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0f7zigvlzl91f7yn845ijzda70vq1b600nsfrvrhckrrgp3l0nyx";
      type = "gem";
    };
    version = "1.11.1";
  };
  simplecov = {
    dependencies = ["docile" "simplecov-html" "simplecov_json_formatter"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "198kcbrjxhhzca19yrdcd6jjj9sb51aaic3b0sc3pwjghg3j49py";
      type = "gem";
    };
    version = "0.22.0";
  };
  simplecov-cobertura = {
    dependencies = ["rexml" "simplecov"];
    groups = ["test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00izmp202y48qvmvwrh5x56cc5ivbjhgkkkjklvqmqzj9pik4r9c";
      type = "gem";
    };
    version = "2.1.0";
  };
  simplecov-html = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "02zi3rwihp7rlnp9x18c9idnkx7x68w6jmxdhyc0xrhjwrz0pasx";
      type = "gem";
    };
    version = "0.13.1";
  };
  simplecov_json_formatter = {
    groups = ["default" "test"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a5l0733hj7sk51j81ykfmlk2vd5vaijlq9d5fn165yyx3xii52j";
      type = "gem";
    };
    version = "0.1.4";
  };
  sorbet-runtime = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "179zisvpd0rz2h7vjdvpd1rnnj8vi7nxpgv3nrqz6n2i1kvsl2ll";
      type = "gem";
    };
    version = "0.5.11761";
  };
  super_diff = {
    dependencies = ["attr_extras" "diff-lcs" "patience_diff"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "055r1hgl0ykym6hzqc2awxlx2faqqgprfn70bil5gva9x8kpr18w";
      type = "gem";
    };
    version = "0.15.0";
  };
  tabitha = {
    dependencies = ["async" "ruby_tree_sitter"];
    groups = ["default"];
    platforms = [];
    source = {
      path = ./.;
      type = "path";
    };
    version = "0.1.0";
  };
  zeitwerk = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mi7b90hvc6nqv37q27df4i2m27yy56yfy2ki5073474a1h9hi89";
      type = "gem";
    };
    version = "2.7.1";
  };
}
