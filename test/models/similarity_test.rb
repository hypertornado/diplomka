require 'test_helper'

class SimilarityTest < ActionController::TestCase

  test "header parser" do
    assert_equal 578, Similarity.parse_header("#objectKey messif.objects.keys.AbstractObjectKey 0000000578\n")
  end

  test "parse vectors" do
    assert_equal [0.0, 0.627232], Similarity.parse_vector("0.0 0.627232\n")
  end

  test "new york distance" do
    assert_in_delta 4, Similarity.new_york([1.0, 2.0], [0.0, 5.0]), 0.01
  end

  test "sim" do
    sim = Similarity.new(3)

    assert_equal [], sim.get_best(0)

    sim.add_loaded "x x 1", "1.0"
    sim.add_loaded "x x 2", "2.0"
    sim.add_loaded "x x 100", "100.0"
    sim.add_loaded "x x 3", "3.0"


    sim.add_compare "x x 4", "1.7"

    assert_equal [2, 1, 3], sim.get_best(4)


  end

end