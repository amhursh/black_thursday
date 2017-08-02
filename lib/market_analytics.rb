require 'pry'
module MarketAnalytics

  private

    def merchant_paid_invoice_items(merchant_id)
      merchant = @merchants.find_by_id(merchant_id)
      paid_invoices = merchant.invoices.find_all {|invoice| invoice.is_paid_in_full?}
      paid_invoice_items =  paid_invoices.reduce([]) do |total_item_instances, invoice|
        total_item_instances << @invoice_items.id_repo.values.find_all do |item|
          invoice.id == item.invoice_id
        end
        total_item_instances.flatten
      end
    end

    def create_invoice_item_hash_by_attribute(invoice_item_array, attribute_proc)
      invoice_item_array.reduce({}) do |q_hash, invoice_item|
        if !(q_hash.keys.include?(invoice_item.item_id))
          q_hash.store(invoice_item.item_id, attribute_proc.call(invoice_item))
          q_hash
        else
          q_hash[invoice_item.item_id] += attribute_proc.call(invoice_item)
          q_hash
        end
      end
    end

    def invoices_on_this_date(date)
      sales_engine.invoices.find_all_by_date(date)
    end

  public

    def total_revenue_by_date(date)
      invoices_on_this_date(date).inject(0) do |sum, invoice_instance|
        sum + invoice_instance.total
      end
    end

    def top_revenue_earners(number = 20)
      sales_engine.merchants_by_revenue[0..(number - 1)]
    end

    def merchants_ranked_by_revenue
      sales_engine.merchants_by_revenue
    end

    def get_item_quantity_for_merchant(merchant_id)
      merchant = sales_engine.merchants.find_by_id(merchant_id)
      merchant.invoice_items.inject({}) do |quantities, invoice_item|
        quantity = invoice_item.quantity
        if quantities.has_key?(quantity)
          quantities[quantity] << sales_engine.items.find_by_id(invoice_item.item_id)
        else
          quantities[quantity] = [sales_engine.items.find_by_id(invoice_item.item_id)]
        end
        quantities
      end
    end

    def most_sold_item_for_merchant(merchant_id)
      item_quantity = get_item_quantity_for_merchant(merchant_id)
      item_quantity[item_quantity.keys.max]
    end

    def get_items_sold_by_value_for_merchant(merchant_id)
      merchant = sales_engine.merchants.find_by_id(merchant_id)
      merchant.invoice_items.inject({}) do |quantities, invoice_item|
        revenue = invoice_item.quantity * invoice_item.unit_price
        quantities[revenue] = sales_engine.items.find_by_id(invoice_item.item_id)
        quantities
      end
    end

    def best_item_for_merchant(merchant_id)
      items_by_value = get_items_sold_by_value_for_merchant(merchant_id)
      items_by_value[items_by_value.keys.max]
    end

    def merchants_with_pending_invoices
      @merchants.id_repo.values.find_all do |merchant|
        merchant.invoices.any? do |invoice|
          invoice.transactions.none? {|transaction| transaction.result == "success"}
        end
      end
    end
end
