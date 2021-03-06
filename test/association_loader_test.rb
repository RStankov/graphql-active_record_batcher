require_relative 'test_helper'

class FieldInstrumenterTest < Minitest::Test
  def setup
    @loader = GraphQL::ActiveRecordBatcher::AssociationLoader.new(
      FakeSchema::Data::Shop,
      :products
    )
  end

  def test_load_raises_when_object_is_of_right_model_type
    exception = assert_raises(TypeError) do
      @loader.load(FakeSchema::Data::Product.new)
    end

    expected = "FakeSchema::Data::Shop loader can't load association for"\
      " FakeSchema::Data::Product"
    assert_equal expected, exception.message
  end

  def test_perform_preloads_associations_for_all_ids
    shop1 = FakeSchema::Data::Shop.first
    shop2 = FakeSchema::Data::Shop.second

    @loader.load(shop1)
    @loader.load(shop2)

    @loader.perform([shop1, shop2])

    shop1.association(:products).loaded?
    shop2.association(:products).loaded?
  end
end
