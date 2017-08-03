require_relative 'test_helper'
require_relative '../lib/sales_analyst'

class InvoiceAnalyticsTest < Minitest::Test

  attr_reader :sales_engine,
              :sales_analyst

  def setup
    @sales_engine = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices => "./data/invoices.csv"
    })
    @sales_analyst = SalesAnalyst.new(sales_engine)
  end

  def test_include
    invoices = sales_analyst.invoices
    av_invoices = sales_analyst.average_invoices_per_day

    refute_equal nil, invoices
    refute_equal nil, av_invoices
  end

  def test_average_invoices_per_merchant
    sales_analyst = SalesAnalyst.new(sales_engine)

    assert_equal 10.49, sales_analyst.average_invoices_per_merchant
  end

  def test_average_invoices_per_merchant_standard_deviation
    av_invoices = sales_analyst.average_invoices_per_merchant_standard_deviation

    assert_equal 3.29, av_invoices
  end

  def test_top_merchants_by_invoice_count
    top_merchants = sales_analyst.top_merchants_by_invoice_count

    assert_instance_of Array, top_merchants
    assert_instance_of Merchant, top_merchants[0]
  end

  def test_bottom_merchants_by_invoice_count
    bottom_merchants = sales_analyst.bottom_merchants_by_invoice_count

    assert_instance_of Array, bottom_merchants
    assert_instance_of Merchant, bottom_merchants[0]
  end

  def test_average_invoices_per_day
    av_invoices = sales_analyst.average_invoices_per_day

    assert_equal 712.14, av_invoices
  end

  def test_average_invoices_per_day_standard_deviation
    stand_dev = sales_analyst.average_invoices_per_day_standard_deviation

    assert_equal 18.07, stand_dev
  end

  def test_top_days_by_invoice_count
    top_days = sales_analyst.top_days_by_invoice_count

    assert_instance_of Array, top_days
    assert_instance_of String, top_days[0]
    assert_equal 1, top_days.length
  end

  def test_invoice_status
    pending = sales_analyst.invoice_status(:pending)
    shipped = sales_analyst.invoice_status(:shipped)
    returned = sales_analyst.invoice_status(:returned)

    assert_equal 29.55, pending
    assert_equal 56.95, shipped
    assert_equal 13.5, returned
  end

end
