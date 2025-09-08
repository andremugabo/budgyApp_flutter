-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Seed when table name is expense_category (snake_case)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'expense_category') THEN
    INSERT INTO expense_category (id, name, icon, active)
    SELECT uuid_generate_v4(), c.name, c.icon, TRUE
    FROM (VALUES
      ('Food','fastfood'),
      ('Transport','directions_bus'),
      ('Health','local_hospital'),
      ('Shopping','shopping_cart'),
      ('Education','school'),
      ('Bills','receipt_long')
    ) AS c(name, icon)
    WHERE NOT EXISTS (SELECT 1 FROM expense_category ec WHERE ec.name = c.name);
  END IF;
END $$;

-- Seed when table name is expensecategory (camel -> lower, no underscore)
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'expensecategory') THEN
    INSERT INTO expensecategory (id, name, icon, active)
    SELECT uuid_generate_v4(), c.name, c.icon, TRUE
    FROM (VALUES
      ('Food','fastfood'),
      ('Transport','directions_bus'),
      ('Health','local_hospital'),
      ('Shopping','shopping_cart'),
      ('Education','school'),
      ('Bills','receipt_long')
    ) AS c(name, icon)
    WHERE NOT EXISTS (SELECT 1 FROM expensecategory ec WHERE ec.name = c.name);
  END IF;
END $$;

