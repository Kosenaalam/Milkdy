# milkdy

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

// sample of structure
lib/
├── core/
│   ├── constants.dart      # [FIXED DATA] Define 'Base Fat = 60' and 'Milk Rate = 50' here so you don't have to type them again and again.
│   ├── theme.dart          # [STYLE] Define your colors. Example: Primary Green for Farmer (Buying) and Blue for Hotel (Selling).
│   └── utils.dart          # [TOOLS] Small functions, like a helper that changes '2026-02-15' into '15 Feb'.
│
├── data/
│   ├── models/
│   │   ├── user_model.dart # [CONVERTER] Changes 'Customer Info' from Supabase into a format Flutter can read.
│   │   └── entry_model.dart# [CONVERTER] Changes 'Milk Entries' from Supabase into code.
│   └── repositories/
│       ├── milk_repo.dart   # [SUPABASE LINK] This is the ONLY file that talks to Supabase. It fetches the 60-day list and saves new entries.
│       └── auth_repo.dart   # [LOGIN] Handles the phone number login/logout.
│
├── domain/
│   └── pricing_logic.dart   # [MATH ENGINE] The most important file. Write your formula here: (Rate / 60) * Fat * Qty. It doesn't care about UI or DB.
│
├── logic/
│   ├── inward_provider.dart # [IN-MEMORY] Keeps track of the farmer you just clicked on and his "Last Fat" while you are on the entry screen.
│   └── outward_provider.dart# [IN-MEMORY] Keeps track of which hotel is buying milk right now and their "Fixed Rate".
│
└── presentation/            # [UI - EVERYTHING VISIBLE]
    ├── home/
    │   └── home_screen.dart # [MAIN MENU] The first screen with big buttons: "Buy Milk", "Sell Milk", and "Reports".
    ├── inward/-----------------[collection screen      ]
    │   ├── entry_form.dart  # [INPUT BOXES] Where you type the quantity. It asks 'pricing_logic.dart' to show the price on screen.
    │   └── history_list.dart# [60-DAY TABLE] The scrolling list that shows every date. It asks 'milk_repo.dart' for the data.
    ├── outward/--------------[distribution screen]
    │   ├── sale_form.dart   # [SELL BOXES] A simpler screen for hotels where you only type 'Quantity' because the rate is fixed.
    │   └── hotel_ledger.dart# [SALES LIST] A list showing how much milk was delivered to which shop/hotel.
    └── widgets/
        ├── action_button.dart # [REUSABLE BUTTON] One code used for every "Save", "Submit", or "Add" button in the app.
        ├── data_row.dart    # [LIST ITEM] How a single row in the ledger looks (Date | Qty | Rate | Total).
        └── loading.dart     # [SPINNER] The circle that spins while the app talks to Supabase.
-- 1. Table for Customers (Customer A, Customer B, etc.)
CREATE TABLE IF NOT EXISTS customers (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL,
  phone text UNIQUE,
  created_at timestamp with time zone DEFAULT now()
);

-- 2. Table for all Milk & Money activity
CREATE TABLE IF NOT EXISTS distribution_ledger (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  customer_id uuid REFERENCES customers(id) ON DELETE CASCADE,
  entry_type text NOT NULL, -- Must be 'MILK' or 'PAYMENT'
  qty_liter float DEFAULT 0,
  fat_content float DEFAULT 0,
  rate float DEFAULT 0,
  amount_debit float DEFAULT 0,  -- The Bill (Cost of milk)
  amount_credit float DEFAULT 0, -- The Payment (Money received)
  description text,               -- e.g., "Received 5/8/2025"
  created_at timestamp with time zone DEFAULT now()
);

-- 3. SPEED INDEXES: Makes fetching 15 days out of 1 million rows instant
CREATE INDEX idx_ledger_cust_id ON distribution_ledger(customer_id);
CREATE INDEX idx_ledger_time ON distribution_ledger(created_at);

-- 4. BALANCE FUNCTION: Calculates total remaining balance automatically
CREATE OR REPLACE FUNCTION get_total_balance(c_id uuid)
RETURNS float AS $$
  -- Total Milk Bills MINUS Total Payments Received
  SELECT COALESCE(SUM(amount_debit), 0) - COALESCE(SUM(amount_credit), 0)
  FROM distribution_ledger 
  WHERE customer_id = c_id;
$$ LANGUAGE sql;
void _saveData() async {
  double liters = double.tryParse(_litersController.text) ?? 0;
  double dailyRate = double.tryParse(_rateController.text) ?? 0;
  double actualFat = double.tryParse(_fatController.text) ?? 0;
  double received = double.tryParse(_receivedController.text) ?? 0;
  double paid = double.tryParse(_paidController.text) ?? 0;

  // Get last balance
  double previousBalance = await getLastBalance();

  // Calculate
  double adjustedRate = dailyRate * (actualFat / 65.0);
  double amountToday = liters * adjustedRate;
  double newBalance = previousBalance + amountToday - received + paid;

  // Save
  await supabase.from('milk_entries').insert({
    'liters': liters,
    'actual_fat': actualFat,
    'daily_rate': dailyRate,
    'amount': amountToday,
    'received': received,
    'paid': paid,
    'balance': newBalance,
  });
}