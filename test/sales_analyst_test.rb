require_relative 'test_helper'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  attr_reader :sales_engine,
              :sales_analyst

  def setup
    @sales_engine = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices  => "./data/invoices.csv",
      :transactions => "./data/transactions.csv",
      :invoice_items => "./data/invoice_items.csv"
    })
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_average_items_per_merchant
    average_items = sales_analyst.average_items_per_merchant

    assert_equal 2.88, average_items
  end

  def test_average_items_per_merchant_standard_deviation
    standard_deviation = sales_analyst.average_items_per_merchant_standard_deviation

    assert_equal 3.26, standard_deviation
  end

  def test_merchants_with_high_item_count
    high_item_merchants = sales_analyst.merchants_with_high_item_count

    assert_instance_of Array, high_item_merchants
    assert_instance_of Merchant, high_item_merchants[0]
  end

  def test_average_item_price_for_merchant
    merchant_id = 12334105

    average_item_price = sales_analyst.average_item_price_for_merchant(merchant_id)
    assert_equal 16.66, average_item_price
  end

  def test_average_average_price_per_merchant
    average_price = sales_analyst.average_average_price_per_merchant

    assert_instance_of BigDecimal, average_price
    assert_equal 350.29, average_price.to_f
  end

  def test_golden_items
    golden_items = sales_analyst.golden_items

    assert_instance_of Array, golden_items
    assert_instance_of Item, golden_items[0]
  end

  def test_merchants_with_only_one_item
    lonely_merchants = sales_analyst.merchants_with_only_one_item

    assert_instance_of Array, lonely_merchants
    assert_instance_of Merchant, lonely_merchants[0]
    assert lonely_merchants.all? {|merchant| merchant.items.count == 1}
  end

  def test_merchants_with_only_one_item_registered_in_month
    month = "January"
    lonely_merchants = sales_analyst.merchants_with_only_one_item_registered_in_month(month)

    assert_instance_of Array, lonely_merchants
    assert_instance_of Merchant, lonely_merchants[0]
    assert lonely_merchants.all? {|merchant| merchant.items.count == 1}
    assert lonely_merchants.all? {|merchant| merchant.items[0].created_at.month == 1}
  end

  def test_revenue_by_merchant
    revenue = sales_analyst.revenue_by_merchant(12334194)

    assert_instance_of BigDecimal, revenue
    assert_equal 81572.4, revenue.to_f
  end

end
