Testing Mac do
  $data.each do |basename, output|
    testing "#{ basename } output" do
      expected = basename

      macaddr = assert{ Mac.parse(output) }

      assert{ macaddr.is_a?(String) }
      assert{ macaddr =~ Mac::RE }
      assert{ macaddr.list.is_a?(Array) }
      assert{ macaddr == expected }
    end
  end


  testing ".addr" do
    assert{ Mac.addr }
  end
end


BEGIN {
  $testdir = File.dirname(File.expand_path(__FILE__))
  $rootdir = File.dirname($testdir)
  $libdir = File.join($rootdir, 'lib')
  require File.join($libdir, 'macaddr')
  require File.join($testdir, 'testing')

  $datadir = File.join($testdir, 'data')
  $data = {}
  glob = File.join($datadir, '**/**')
  Dir.glob(glob) do |entry|
    key = File.basename(entry)
    val = IO.read(entry)
    $data[key] = val
  end
}
