require 'test_helper'

class BusinessSupportSchemeTest < ActiveSupport::TestCase

  setup do
    @scheme = FactoryGirl.create(:business_support_scheme, 
      title: "Tourism support grant. West Dunbartonshire", 
      business_support_identifier: "99",
      priority: 1, 
      business_types: [], locations: [], sectors: [], stages: [], support_types: [])
  end

  test "should validate presence of title" do
    scheme = BusinessSupportScheme.new(business_support_identifier: "foo-scheme")
    refute scheme.valid?, "should validate presence of title."
    scheme.title = "Foo scheme"
    assert scheme.valid?, "should validate presence of title."
  end
  
  test "should validate uniqueness of title" do
    another_scheme = BusinessSupportScheme.new(
      title: "Tourism support grant. West Dunbartonshire", 
      business_support_identifier: "foo")
    refute another_scheme.valid?, "should validate uniqueness of title."
  end
  
  test "should validate uniqueness of business_support_identifier" do
    another_scheme = BusinessSupportScheme.new(title: "Foo", 
      business_support_identifier: "99")
    refute another_scheme.valid?, "should validate uniqueness of business_support_identifier."
  end

  test "should validate the priority value" do
    scheme = BusinessSupportScheme.new(title: "Foo scheme", business_support_identifier: "1001", priority: nil)
    refute scheme.valid?, "Priority should not be nil"
    scheme.priority = 3
    refute scheme.valid?, "Priority should be 0, 1 or 2"
    scheme.priority = 2
    assert scheme.valid?
  end

  test "should have and belong to many BusinessSupportBusinessTypes" do
    @scheme.business_types << "charity"
    @scheme.business_types << "private-company"
    assert_equal "charity", @scheme.business_types.first
    assert_equal "private-company", @scheme.business_types.last
  end
 
  test "should have and belong to many BusinessSupportNations" do
    @scheme.locations << "auchtermuchty"
    @scheme.locations << "ecclefechan"
    @scheme.locations << "london"
    assert_equal "auchtermuchty", @scheme.locations.first
    assert_equal "london", @scheme.locations.last 
  end
  
  test "should have and belong to many BusinessSupportSectors" do
    @scheme.sectors << "finance"
    @scheme.sectors << "law"
    @scheme.sectors << "media"
    assert_equal "finance", @scheme.sectors.first
    assert_equal "media", @scheme.sectors.last
  end
  
  test "should have and belong to many BusinessSupportStages" do
    @scheme.stages << "start-up"
    @scheme.stages << "grow-and-sustain"
    assert_equal "start-up", @scheme.stages.first
    assert_equal "grow-and-sustain", @scheme.stages.last 
  end
  
  test "should have and belong to many BusinessSupportTypes" do
    @scheme.support_types << "award"
    @scheme.support_types << "loan"
    assert_equal "award", @scheme.support_types.first
    assert_equal "loan", @scheme.support_types.last 
  end
 
  test "should have and belong to many BusinessSupportPurposes" do
    @scheme.business_support_purposes << BusinessSupportPurpose.new(name: "Business growth and expansion")
    @scheme.business_support_purposes << BusinessSupportPurpose.new(name: "Setting up your business")
    assert_equal "Business growth and expansion", @scheme.business_support_purposes.first.name
    assert_equal "Setting up your business", @scheme.business_support_purposes.last.name 
  end 

  test "should be scoped by relations and ordered by priority then title" do
    @another_scheme = FactoryGirl.create(:business_support_scheme, title: "Wunderscheme", 
                                         business_support_identifier: "123",
                                         priority: 2,
                                         business_types: [], locations: [], sectors: [], stages: [], support_types: [])
    @start_up = FactoryGirl.create(:business_support_stage, name: "Start up", slug: "start-up")
    @scheme.stages << @start_up.slug
    @scheme.save!
    @another_scheme.stages << @start_up.slug
    @another_scheme.save!
    assert_equal @another_scheme, BusinessSupportScheme.for_relations(stages: "start-up").first
    assert_equal @scheme, BusinessSupportScheme.for_relations(stages: "start-up").second
    assert_equal @another_scheme, BusinessSupportScheme.for_relations(stages: "start-up", sectors: "manufacturing").first
    @manufacturing = FactoryGirl.create(:business_support_sector, name: "Manufacturing", slug: "manufacturing")
    @scheme.sectors << @manufacturing.slug
    @another_scheme.sectors << @manufacturing.slug
    @scheme.save!
    @another_scheme.save!
    assert_equal 0, BusinessSupportScheme.for_relations(stages: "start-up", sectors: "Agriculture").count
    assert_equal @another_scheme, BusinessSupportScheme.for_relations(stages: "start-up", sectors: "agriculture,manufacturing").first
    assert_equal @scheme, BusinessSupportScheme.for_relations(stages: "start-up", sectors: "agriculture,manufacturing").second
  end

  test "before validation on create callback" do
    bs = BusinessSupportScheme.new(title: "Brand new scheme")
    bs.save
    assert_equal "100", bs.business_support_identifier
  end

  test "before validation on create callback when business_support_identifier exists" do
    bs = BusinessSupportScheme.new(title: "Brand new scheme", business_support_identifier: "111")
    bs.save
    assert_equal "111", bs.business_support_identifier
  end
  
  test "next_identifier" do
    assert_equal 100, BusinessSupportScheme.next_identifier
  end
end
