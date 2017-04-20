class TestSerializer < ActiveModel::Serializer
  attributes :test_name

  def test_name
    'name test'
  end
end
