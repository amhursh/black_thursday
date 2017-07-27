require 'time'

class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :invoice_repo

  def initialize(invoice_info, invoice_repo)
    @id =             invoice_info[:id].to_i
    @customer_id =    invoice_info[:customer_id].to_i
    @merchant_id =    invoice_info[:merchant_id].to_i
    @status =         invoice_info[:status]
    @created_at =     Time.parse(invoice_info[:created_at])
    @updated_at =     Time.parse(invoice_info[:updated_at])
  end

  def merchant
    merchant_repo = @invoice_repo.sales_engine.merchants
    merchant_repo.find_by_id(@merchant_id)
  end

end
