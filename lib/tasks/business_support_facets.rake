require 'business_support_facet_manager'

namespace :business_support_facets do
  desc "Switches facet ids for facet slugs in business support schemes"
  task :facet_ids_to_slugs => :environment do
    BusinessSupportFacetManager.facet_ids_to_slugs
  end
  desc "Adds relationships to every facet instance where none exist on the scheme"
  task :populate_empty_collections => :environment do
    BusinessSupportFacetManager.populate_empty_collections
  end
end
