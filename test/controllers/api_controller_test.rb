require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end


  #test "tokenizer" do
  #  assert_equal ["á", "b"], ApiController.tokenize(" Á           , B    ")
  #end

  test "term_frequency" do
    text = "hello world hello"
    freq = ApiController.term_frequency text
    assert_equal 1, freq["world"]
    assert_equal 2, freq["hello"]
  end

end
