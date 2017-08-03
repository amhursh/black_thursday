require_relative 'test_helper'
require_relative '../lib/sales_analyst'

class MarketAnalyticsTest < Minitest::Test

  attr_reader :sales_engine,
              :sales_analyst

  def setup
    @sales_engine = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv"
    })
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_include
    invoice_items = sales_analyst.invoice_items
    transactions = sales_analyst.transactions
    total_rev_by_date = sales_analyst.total_revenue_by_date(Time.new(2013, 12, 20))

    refute_nil invoice_items
    refute_nil transactions
    refute_nil total_rev_by_date
  end

  def test_total_revenue_by_date
    date = Time.parse("2009-02-07")
    total_revenue = sales_analyst.total_revenue_by_date(date)

    assert_equal 21067.77, total_revenue
  end

  def test_revenue_by_merchant
    revenue_1 = sales_analyst.revenue_by_merchant(12334228)
    revenue_2 = sales_analyst.revenue_by_merchant(12334832)

    assert_equal 135598.55, revenue_1
    assert_equal 101405.90, revenue_2
  end

  def test_top_revenue_earners_default
    top_earners = sales_analyst.top_revenue_earners

    assert_instance_of Array, top_earners
    assert_instance_of Merchant, top_earners[0]
    assert_equal 20, top_earners.length
    refute_equal top_earners[0], top_earners[1]
  end

  def test_top_revenue_earners_with_argument
    top_five = sales_analyst.top_revenue_earners(5)
    top_earners = sales_analyst.top_revenue_earners

    assert_instance_of Array, top_five
    assert_instance_of Merchant, top_five[0]
    assert_equal 5, top_five.length
    refute_equal top_earners[0], top_five[1]
  end

  def test_most_sold_item_for_merchant
    item_1 = sales_analyst.most_sold_item_for_merchant(12334228)
    item_2 = sales_analyst.most_sold_item_for_merchant(12334832)

    assert_instance_of Array, item_1
    assert_instance_of Item, item_1[0]
    assert_instance_of Array, item_2
    assert_instance_of Item, item_2[0]
  end

  def test_best_item_for_merchant
    item_1 = sales_analyst.best_item_for_merchant(12334228)
    item_2 = sales_analyst.best_item_for_merchant(12334832)

    assert_instance_of Item, item_1
    assert_instance_of Item, item_2
  end

  def test_merchants_with_pending_invoices
    pending_merchants = sales_analyst.merchants_with_pending_invoices

    assert_instance_of Array, pending_merchants
    assert_instance_of Merchant, pending_merchants[0]
  end

  def test_market_analyst_can_get_sold_items_by_quantity_for_merchant
    items = sales_analyst.get_item_quantity_for_merchant(12334189)

    assert_instance_of Hash, items
    assert_instance_of Item, items.values[0][0]
  end

  def test_market_analyst_can_get_most_sold_item_for_merchant
    item = sales_analyst.most_sold_item_for_merchant(12334189)

    assert_equal 263524984, item[0].id
  end

  def test_market_analyst_can_get_sold_items_by_revenue_for_merchant
    items = sales_analyst.get_items_sold_by_value_for_merchant(12334189)

    assert_instance_of Hash, items
    assert_instance_of Item, items.values[0]
  end

  def test_market_analyst_can_get_best_item_for_merchant
    item = sales_analyst.most_sold_item_for_merchant(12334189)

    assert_equal 263524984, item[0].id
  end

end
