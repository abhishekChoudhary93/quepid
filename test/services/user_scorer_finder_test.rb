# frozen_string_literal: true

require 'test_helper'

class UserScorerFinderTest < ActiveSupport::TestCase
  let(:doug)          { users(:doug) }
  let(:owned_scorer)  { scorers(:owned_scorer) }
  let(:shared_scorer) { scorers(:shared_scorer) }

  let(:service)       { UserScorerFinder.new(doug) }

  describe 'Find all scorers' do
    test 'returns an array of scorers' do
      result = service.all

      assert_instance_of Scorer::ActiveRecord_Relation, result
    end

    test 'includes scorers owned by user' do
      result = service.all

      assert_includes result, owned_scorer
    end

    test 'includes scorers shared with user' do
      result = service.all

      assert_includes result, shared_scorer
    end
  end

  describe 'Find all scorers that match params' do
    test 'returns an empty array if no results match' do
      result = service.where(id: 123).all

      assert_instance_of  Scorer::ActiveRecord_Relation, result
      assert_equal        0, result.length
    end

    test 'works when filtering by id' do
      result = service.where(id: owned_scorer.id).all

      assert_instance_of  Scorer::ActiveRecord_Relation, result
      assert_equal        1,      result.length
      assert_includes     result, owned_scorer
    end

    test 'works with complex where clause for owned scorers' do
      result = service.where('`scorers`.`name` LIKE ?', '%Owned%').all

      assert_instance_of  Scorer::ActiveRecord_Relation, result
      assert_equal        3,      result.length
      assert_includes     result, owned_scorer
    end

    test 'works with complex where clause for shared scorers' do
      result = service.where('`scorers`.`name` LIKE ?', '%Shared%').all

      assert_instance_of  Scorer::ActiveRecord_Relation, result
      assert_equal        3,      result.length
      assert_not_includes result, owned_scorer
      assert_includes     result, shared_scorer
    end

    test 'works when querying on the name for owned scorers' do
      result = service.where(name: 'Owned Scorer').all

      assert_instance_of  Scorer::ActiveRecord_Relation, result
      assert_equal        1,      result.length
      assert_includes     result, owned_scorer
    end

    test 'works when querying on the name for shared scorers' do
      result = service.where(name: 'Shared Scorer').all

      assert_instance_of  Scorer::ActiveRecord_Relation, result
      assert_equal        1,      result.length
      assert_not_includes result, owned_scorer
      assert_includes     result, shared_scorer
    end
  end

  describe 'Find first scorer that matches params' do
    test 'returns nil if no results match' do
      result = service.where(id: 123).first

      assert_nil result
    end

    test 'works when filtering by id' do
      result = service.where(id: owned_scorer.id)
        .order(name: :asc)
        .first

      assert_instance_of  Scorer, result
      assert_equal        result, owned_scorer
    end

    test 'works with complex where clause for owned scorers' do
      result = service.where('`scorers`.`name` LIKE ?', '%Owned%')
        .order(name: :asc)
        .first

      assert_instance_of  Scorer, result
      assert_equal        result, owned_scorer
    end

    test 'works with complex where clause for shared scorers' do
      result = service.where('`scorers`.`name` LIKE ?', '%Shared%')
        .order(name: :asc)
        .first

      assert_instance_of  Scorer, result
      assert_not_equal    result, owned_scorer
      assert_equal        result, shared_scorer
    end

    test 'works when querying on the name for owned scorers' do
      result = service.where(name: 'Owned Scorer')
        .order(name: :asc)
        .first

      assert_instance_of  Scorer,  result
      assert_equal        result, owned_scorer
    end

    test 'works when querying on the name for shared scorers' do
      result = service.where(name: 'Shared Scorer')
        .order(name: :asc)
        .first

      assert_instance_of  Scorer,  result
      assert_not_equal    result, owned_scorer
      assert_equal        result, shared_scorer
    end
  end

  describe 'Find last scorer that matches params' do
    test 'returns nil if no results match' do
      result = service.where(id: 123).last

      assert_nil result
    end

    test 'works when filtering by id' do
      result = service.where(id: owned_scorer.id)
        .order(name: :desc)
        .last

      assert_instance_of  Scorer, result
      assert_equal        result, owned_scorer
    end

    test 'works with complex where clause for owned scorers' do
      result = service.where('`scorers`.`name` LIKE ?', '%Owned%')
        .order(name: :desc)
        .last

      assert_instance_of  Scorer, result
      assert_equal        result, owned_scorer
    end

    test 'works with complex where clause for shared scorers' do
      result = service.where('`scorers`.`name` LIKE ?', '%Shared%')
        .order(name: :desc)
        .last

      assert_instance_of  Scorer, result
      assert_not_equal    result, owned_scorer
      assert_equal        result, shared_scorer
    end

    test 'works when querying on the name for owned scorers' do
      result = service.where(name: 'Owned Scorer')
        .order(name: :desc)
        .last

      assert_instance_of  Scorer,  result
      assert_equal        result, owned_scorer
    end

    test 'works when querying on the name for shared scorers' do
      result = service.where(name: 'Shared Scorer')
        .order(name: :desc)
        .last

      assert_instance_of  Scorer,  result
      assert_not_equal    result, owned_scorer
      assert_equal        result, shared_scorer
    end
  end
end