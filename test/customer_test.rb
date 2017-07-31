require_relative 'test_helper'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test

  def test_customer_exists
    customer = Customer.new({
      :id => 230, :first_name => "Matilda", :last_name => "Connelly",
      :created_at => "2012-03-27 14:55:06 UTC",
      :updated_at => "2012-03-27 14:55:06 UTC"
      }, self)

    assert_instance_of Customer, customer
  end

  def test_customer_has_id
    customer = Customer.new({
      :id => 230, :first_name => "Matilda", :last_name => "Connelly",
      :created_at => "2012-03-27 14:55:06 UTC",
      :updated_at => "2012-03-27 14:55:06 UTC"
      }, self)
    id = customer.id

    assert_equal 230, id
  end

  def test_customer_has_first_name
    customer = Customer.new({
      :id => 230, :first_name => "Matilda", :last_name => "Connelly",
      :created_at => "2012-03-27 14:55:06 UTC",
      :updated_at => "2012-03-27 14:55:06 UTC"
      }, self)
    first = customer.first_name

    assert_equal "Matilda", first
  end

  def test_customer_has_last_name
    customer = Customer.new({
      :id => 230, :first_name => "Matilda", :last_name => "Connelly",
      :created_at => "2012-03-27 14:55:06 UTC",
      :updated_at => "2012-03-27 14:55:06 UTC"
      }, self)
    last = customer.last_name

    assert_equal "Connelly", last
  end

end
