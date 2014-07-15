require 'test_helper'

class LanguageToolTest < ActionController::TestCase

  test 'supported languages' do
    assert_nothing_raised do
      LanguageTool.new('en')
    end

    assert_raise(Exception) do
      LanguageTool.new('unsupported language')
    end
  end

  test "tokenize" do
    tool = LanguageTool.new('en')
    assert_equal("a", tool.tokenize("a b")[0])
    assert_equal("a", tool.tokenize("a,b")[0])
    assert_equal("a", tool.tokenize("a9b")[0])
    assert_equal("b", tool.tokenize("a  b")[1])
  end

  test "word stemmer" do
    tool = LanguageTool.new('cs')
    assert_equal("jarn", tool.stem_word("jarní"))
    assert_equal("mlad", tool.stem_word("mladý"))
    assert_equal("jarn mlad", tool.stem_line("jarní mladý"))

    tool = LanguageTool.new('en')
    assert_equal("car", tool.stem_word("cars"))
  end

  test "lowercase line" do
    tool = LanguageTool.new('cs')
    assert_equal("řžšťůú", tool.lowercase_line("ŘŽŠŤŮÚ"))
  end

  test "translate line" do
    tool = LanguageTool.new('en')
    assert_equal("oko ústa", tool.translate_line("eye  Mouth", "cs"))
    assert_equal("korouhvička", tool.translate_line("WEather  vane", "cs"))
    assert_equal("oko jsou zpětná zrcátka ústa", tool.translate_line("eye rear view mirrors mouth", "cs"))

  end

end