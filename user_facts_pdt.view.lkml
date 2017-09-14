view: user_facts_pdt {
    derived_table: {
      sql:
      SELECT
        customer_id, created_date.month,
        MIN(orders.created_date) AS first_order_date,
        MAX(orders.created_date) AS latest_order_date,
        COUNT(orders.ID) AS total_orders
        DATEDIFF(first_order_date, CURDATE()) AS days_since_first_order,
        FROM user
        LEFT JOIN orders ON users.id = orders.customed_id
        GROUP BY customer_id;;
    }
  dimension: customer_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: created_date_month {
    type: date_fiscal_month_num
    sql: ${TABLE}.created_date_month ;;
  }

  dimension: first_order_date {
    type: date
    sql: ${TABLE}.first_order_date ;;
  }

  dimension: latest_order_date {
    type: date
    sql: ${TABLE}.latest_order_date ;;
  }

  dimension: total_orders {
    type: number
    sql: ${TABLE}.total_orders ;;
  }

  dimension: days_since_first_order{
    type: number
    sql: ${TABLE}.days_since_first_order ;;
  }

  measure: repeat_customer {
    type: yesno
    sql: ${days_since_first_order}>1 ;;
  }

  measure: average_orders_per_month {
    type: average
    sql: ${total_orders}/${created_date_month} ;;
  }
  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: user_facts_pdt {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
