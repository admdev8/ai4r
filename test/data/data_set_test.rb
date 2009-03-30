# Author::    Sergio Fierens
# License::   MPL 1.1
# Project::   ai4r
# Url::       http://ai4r.rubyforge.org/
#
# You can redistribute it and/or modify it under the terms of 
# the Mozilla Public License version 1.1  as published by the 
# Mozilla Foundation at http://www.mozilla.org/MPL/MPL-1.1.txt

require 'test/unit'
require File.dirname(__FILE__) + '/../../lib/ai4r/data/data_set'

module Ai4r
  module Data
    class DataSetTest < Test::Unit::TestCase
      
      def test_load_csv_with_labels
        set = DataSet.new.load_csv_with_labels("#{File.dirname(__FILE__)}/data_set.csv")
        assert_equal 120, set.data_items.length
        assert_equal ["zone", "rooms", "size", "price"], set.data_labels
      end
      
      def test_build_domains
        domains =  [  Set.new(["New York", "Chicago"]), 
                      Set.new(["M", "F"]), 
                      Set.new(["Y", "N"]) ]
        data = [  [ "New York", "M", "Y"],
                  [ "Chicago", "M", "Y"],
                  [ "New York", "F", "Y"],
                  [ "New York", "M", "N"],
                  [ "Chicago", "M", "N"],
                  [ "Chicago", "F", "Y"] ]
        labels = ["city", "gender", "result"]
        set = DataSet.new({:data_items => data, :data_labels => labels})
        assert_equal domains, set.build_domains
        assert_equal domains[0], set.build_domain("city")
        assert_equal domains[1], set.build_domain(1)
        assert_equal domains[2], set.build_domain("result")
      end
      
      def test_set_data_labels
        labels = ["A", "B"]
        set = DataSet.new.set_data_labels(labels)
        assert_equal labels, set.data_labels
        set = DataSet.new(:data_labels => labels)
        assert_equal labels, set.data_labels
        set = DataSet.new(:data_items => [[ 1, 2, 3]])
        assert_raise(ArgumentError) { set.set_data_labels(labels) }
      end

      def test_set_data_items
        items = [  [ "New York", "M", "Y"],
                  [ "Chicago", "M", "Y"],
                  [ "New York", "F", "Y"],
                  [ "New York", "M", "N"],
                  [ "Chicago", "M", "N"],
                  [ "Chicago", "F", "Y"] ]
        set = DataSet.new.set_data_items(items)
        assert_equal items, set.data_items
        assert_equal 3, set.data_labels.length
        items << items.first[0..-2]
        assert_raise(ArgumentError) { set.set_data_items(items) }
        assert_raise(ArgumentError) { set.set_data_items(nil) }
        assert_raise(ArgumentError) { set.set_data_items([1]) }
      end
     
      def test_get_mean_or_mode
                items = [  [ "New York", 25, "Y"],
                  [ "New York", 55, "Y"],
                  [ "Chicago", 23, "Y"],
                  [ "Boston", 23, "N"],
                  [ "Chicago", 12, "N"],
                  [ "Chicago", 87, "Y"] ]
        set = DataSet.new.set_data_items(items)
        assert_equal ["Chicago", 37.5, "Y"], set.get_mean_or_mode
      end
     
    end
  end
end
