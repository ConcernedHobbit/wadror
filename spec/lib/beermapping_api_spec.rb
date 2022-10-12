require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "when HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { "Content-Type" => "text/xml" })
      
      places = BeermappingApi.places_in("turku")
      
      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  
    it "when HTTP GET returns no entries, an empty table is returned" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING
      
      stub_request(:get, /.*porvoo/).to_return(body: canned_answer, headers: { "Content-Type" => "text/xml" })
      
      places = BeermappingApi.places_in("porvoo")
      
      expect(places.empty?).to be_truthy
    end
    
    it "when HTTP GET returns multiple entires, they are parsed and returned" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6742</id><name>Pullman Bar</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6742</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap><street>Kaivokatu 1</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 9 0307 22</phone><overall>72.500025</overall><imagecount>0</imagecount></location><location><id>6743</id><name>Belge</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6743</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap><street>Kluuvikatu 5</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 10 766 35</phone><overall>67.499925</overall><imagecount>1</imagecount></location><location><id>6919</id><name>Suomenlinnan Panimo</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/6919</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6919&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6919&amp;d=1&amp;type=norm</blogmap><street>Rantakasarmi</street><city>Helsinki</city><state></state><zip>00190</zip><country>Finland</country><phone>+358 9 228 5030</phone><overall>69.166625</overall><imagecount>0</imagecount></location><location><id>12408</id><name>St. Urho's Pub</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/12408</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12408&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12408&amp;d=1&amp;type=norm</blogmap><street>Museokatu 10</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 9 5807 7222</phone><overall>95</overall><imagecount>0</imagecount></location><location><id>12409</id><name>Kaisla</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/12409</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12409&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12409&amp;d=1&amp;type=norm</blogmap><street>Vilhonkatu 4</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 10 76 63850</phone><overall>83.3334</overall><imagecount>0</imagecount></location><location><id>12410</id><name>Pikkulintu</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/12410</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12410&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12410&amp;d=1&amp;type=norm</blogmap><street>Klaavuntie 11</street><city>Helsinki</city><state></state><zip>00910</zip><country>Finland</country><phone>+358 9 321 5040</phone><overall>91.6667</overall><imagecount>0</imagecount></location><location><id>18418</id><name>Bryggeri Helsinki</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18418</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18418&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18418&amp;d=1&amp;type=norm</blogmap><street>Sofiankatu 2</street><city>Helsinki</city><state></state><zip>FI-00170</zip><country>Finland</country><phone>010 235 2500</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18844</id><name>Stadin Panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/18844</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18844&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18844&amp;d=1&amp;type=norm</blogmap><street>Kaasutehtaankatu 1, rakennus 6</street><city>Helsinki</city><state></state><zip>00540</zip><country>Finland</country><phone>09 170512</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18855</id><name>Panimoravintola Bruuveri</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18855</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18855&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18855&amp;d=1&amp;type=norm</blogmap><street>Fredrikinkatu 63AB</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>09 685 66 88</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21532</id><name>Ohrana Krouvin panimo</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/21532</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21532&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21532&amp;d=1&amp;type=norm</blogmap><street>Korkeavuorenkatu 27</street><city>Helsinki</city><state>Etela-Suomen Laani</state><zip>00130</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21543</id><name>Perhon panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21543</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21543&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21543&amp;d=1&amp;type=norm</blogmap><street>Mechelininkatu 7</street><city>Helsinki</city><state>Etela-Suomen Laani</state><zip>00100</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21804</id><name>Brewdog Helsinki</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/21804</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21804&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21804&amp;d=1&amp;type=norm</blogmap><street>Tarkk'ampujankatu 20</street><city>Helsinki</city><state></state><zip>00150</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING
      
      stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: { "Content-Type" => "text/xml" })
      
      places = BeermappingApi.places_in("helsinki")
      
      expect(places.size).to eq(12)
      expect(places.all? { |element| element.instance_of? Place }).to be_truthy
    end
  end

  describe "in case of cache hit" do
    before :each do
      Rails.cache.clear
    end

    it "when HTTP GET returns one entry, it is parsed and returned" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>18856</id><name>Panimoravintola Koulu</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18856</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18856&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18856&amp;d=1&amp;type=norm</blogmap><street>Eerikinkatu 18</street><city>Turku</city><state></state><zip>20100</zip><country>Finland</country><phone>(02) 274 5757</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*turku/).to_return(body: canned_answer, headers: { "Content-Type" => "text/xml" })
      
      BeermappingApi.places_in("turku")
      places = BeermappingApi.places_in("turku")
      
      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Panimoravintola Koulu")
      expect(place.street).to eq("Eerikinkatu 18")
    end
  
    it "when HTTP GET returns no entries, an empty table is returned" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING
      
      stub_request(:get, /.*porvoo/).to_return(body: canned_answer, headers: { "Content-Type" => "text/xml" })
      
      BeermappingApi.places_in("porvoo")
      places = BeermappingApi.places_in("porvoo")
      
      expect(places.empty?).to be_truthy
    end
    
    it "when HTTP GET returns multiple entires, they are parsed and returned" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6742</id><name>Pullman Bar</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6742</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap><street>Kaivokatu 1</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 9 0307 22</phone><overall>72.500025</overall><imagecount>0</imagecount></location><location><id>6743</id><name>Belge</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/6743</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap><street>Kluuvikatu 5</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 10 766 35</phone><overall>67.499925</overall><imagecount>1</imagecount></location><location><id>6919</id><name>Suomenlinnan Panimo</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/6919</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6919&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6919&amp;d=1&amp;type=norm</blogmap><street>Rantakasarmi</street><city>Helsinki</city><state></state><zip>00190</zip><country>Finland</country><phone>+358 9 228 5030</phone><overall>69.166625</overall><imagecount>0</imagecount></location><location><id>12408</id><name>St. Urho's Pub</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/12408</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12408&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12408&amp;d=1&amp;type=norm</blogmap><street>Museokatu 10</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 9 5807 7222</phone><overall>95</overall><imagecount>0</imagecount></location><location><id>12409</id><name>Kaisla</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/12409</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12409&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12409&amp;d=1&amp;type=norm</blogmap><street>Vilhonkatu 4</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>+358 10 76 63850</phone><overall>83.3334</overall><imagecount>0</imagecount></location><location><id>12410</id><name>Pikkulintu</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/12410</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12410&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12410&amp;d=1&amp;type=norm</blogmap><street>Klaavuntie 11</street><city>Helsinki</city><state></state><zip>00910</zip><country>Finland</country><phone>+358 9 321 5040</phone><overall>91.6667</overall><imagecount>0</imagecount></location><location><id>18418</id><name>Bryggeri Helsinki</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18418</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18418&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18418&amp;d=1&amp;type=norm</blogmap><street>Sofiankatu 2</street><city>Helsinki</city><state></state><zip>FI-00170</zip><country>Finland</country><phone>010 235 2500</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18844</id><name>Stadin Panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/18844</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18844&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18844&amp;d=1&amp;type=norm</blogmap><street>Kaasutehtaankatu 1, rakennus 6</street><city>Helsinki</city><state></state><zip>00540</zip><country>Finland</country><phone>09 170512</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>18855</id><name>Panimoravintola Bruuveri</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/18855</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=18855&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=18855&amp;d=1&amp;type=norm</blogmap><street>Fredrikinkatu 63AB</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone>09 685 66 88</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21532</id><name>Ohrana Krouvin panimo</name><status>Brewpub</status><reviewlink>https://beermapping.com/location/21532</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21532&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21532&amp;d=1&amp;type=norm</blogmap><street>Korkeavuorenkatu 27</street><city>Helsinki</city><state>Etela-Suomen Laani</state><zip>00130</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21543</id><name>Perhon panimo</name><status>Brewery</status><reviewlink>https://beermapping.com/location/21543</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21543&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21543&amp;d=1&amp;type=norm</blogmap><street>Mechelininkatu 7</street><city>Helsinki</city><state>Etela-Suomen Laani</state><zip>00100</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location><location><id>21804</id><name>Brewdog Helsinki</name><status>Beer Bar</status><reviewlink>https://beermapping.com/location/21804</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=21804&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=21804&amp;d=1&amp;type=norm</blogmap><street>Tarkk'ampujankatu 20</street><city>Helsinki</city><state></state><zip>00150</zip><country>Finland</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING
      
      stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: { "Content-Type" => "text/xml" })
      
      BeermappingApi.places_in("helsinki")
      places = BeermappingApi.places_in("helsinki")
      
      expect(places.size).to eq(12)
      expect(places.all? { |element| element.instance_of? Place }).to be_truthy
    end
  end
end