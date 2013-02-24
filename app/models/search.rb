class Search < ActiveRecord::Base
  belongs_to :searchable, polymorphic: true
  attr_accessible :searchable_id, :searchable_type, :document
  # default_scope include: :searchable

  def self.search_with_fuzzy_query_matching(query)
    return [] if query.blank? || (query.is_a?(Hash) && query[:document].blank?)

    if query.is_a?(Hash)
      query[:document] = "'#{query[:document]}':*"
    else
      query = "'#{query}':*"
    end

    self.search query
  end

  # Our table doesn't have primary keys, so we need
  # to be explicit about how to tell different search
  # results apart; without this, we can't use :include
  # to avoid n + 1 query problems
  def hash; [searchable_id, searchable_type].hash; end

  def eql?(result)
    self.searchable_id == result.searchable_id && self.searchable_type == result.searchable_type
  end
end
