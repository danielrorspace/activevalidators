require 'test_helper.rb'

describe "Url Validation" do
  def build_url_record
    TestRecord.reset_callbacks(:validate)
    TestRecord.validates :url, :url => true
    TestRecord.new
  end

  describe "valid urls" do
    it "accepts urls without port number" do
      subject = build_url_record
      subject.url = 'http://www.verrot.fr'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts urls with port number" do
      subject = build_url_record
      subject.url = 'http://www.verrot.fr:1234'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end

    it "accepts urls with basic auth" do
      subject = build_url_record
      subject.url = 'http://foo:bar@www.verrot.fr'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end
    it "accepts valid SSL urls" do
      subject = build_url_record
      subject.url = 'https://www.verrot.fr'
      subject.valid?.must_equal true
      subject.errors.size.must_equal 0
    end
  end

  describe "for invalid urls" do
    it "rejects invalid urls" do
      subject = build_url_record
      subject.url = 'http://^^^^.fr'
      subject.valid?.must_equal false
      subject.errors.size.must_equal 1
    end

    it "generates an error message of type invalid" do
      subject = build_url_record
      subject.url = 'http://^^^^.fr'
      subject.valid?.must_equal false
      subject.errors[:url].include?(subject.errors.generate_message(:url, :invalid)).must_equal true
    end
  end
end
