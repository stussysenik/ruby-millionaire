puts "Seeding AeroParts Pro..."

# ─── Users ────────────────────────────────────────────────────────────

admin = User.find_or_create_by!(email_address: "admin@aeroparts.pro") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.first_name = "Admin"
  u.last_name = "User"
  u.admin = true
end
puts "  Admin: admin@aeroparts.pro / password123"

customer = User.find_or_create_by!(email_address: "pilot@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.first_name = "James"
  u.last_name = "Mitchell"
  u.phone = "+1 (555) 234-5678"
end
puts "  Customer: pilot@example.com / password123"

# ─── Categories ───────────────────────────────────────────────────────

categories_data = [
  {
    name: "Fasteners",
    slug: "fasteners",
    description: "Aircraft-grade bolts, nuts, screws, and rivets meeting NAS, AN, and MS specifications. Titanium, A286, and Inconel options available.",
    position: 1,
    children: [
      { name: "Bolts", slug: "bolts", description: "Hex head, internal wrenching, and 12-point bolts", position: 1 },
      { name: "Nuts", slug: "nuts", description: "Self-locking, castellated, and anchor nuts", position: 2 },
      { name: "Rivets", slug: "rivets", description: "Solid, blind, and Hi-Lok rivets", position: 3 }
    ]
  },
  {
    name: "Seals & Gaskets",
    slug: "seals-gaskets",
    description: "High-performance O-rings, gaskets, and sealing solutions for hydraulic, pneumatic, and fuel systems. Temperature range -65°F to +450°F.",
    position: 2,
    children: [
      { name: "O-Rings", slug: "o-rings", description: "Fluorocarbon, silicone, and PTFE O-rings", position: 1 },
      { name: "Gaskets", slug: "gaskets", description: "Spiral wound and metal gaskets", position: 2 }
    ]
  },
  {
    name: "Bearings",
    slug: "bearings",
    description: "Precision aerospace bearings for flight controls, engines, and landing gear. ABEC-7 and ABEC-9 tolerance classes.",
    position: 3,
    children: [
      { name: "Ball Bearings", slug: "ball-bearings", description: "Deep groove and angular contact", position: 1 },
      { name: "Rod End Bearings", slug: "rod-end-bearings", description: "Self-aligning rod ends", position: 2 }
    ]
  },
  {
    name: "Avionics",
    slug: "avionics",
    description: "Electronic components for navigation, communication, and flight management systems. DO-160G qualified.",
    position: 4,
    children: [
      { name: "Connectors", slug: "connectors", description: "MIL-DTL-38999 and D-sub connectors", position: 1 },
      { name: "Wire & Cable", slug: "wire-cable", description: "MIL-W-22759 Tefzel wire", position: 2 }
    ]
  },
  {
    name: "Composites",
    slug: "composites",
    description: "Carbon fiber, fiberglass, and aramid composite materials and pre-preg systems for structural and interior applications.",
    position: 5,
    children: []
  },
  {
    name: "Hydraulics",
    slug: "hydraulics",
    description: "Hydraulic fittings, hoses, actuators, and accumulators for 3000 PSI and 5000 PSI systems. MIL-H-5606 compatible.",
    position: 6,
    children: [
      { name: "Fittings", slug: "hydraulic-fittings", description: "AN and MS hydraulic fittings", position: 1 },
      { name: "Hoses", slug: "hydraulic-hoses", description: "High-pressure hydraulic hoses", position: 2 }
    ]
  }
]

categories = {}
categories_data.each do |cat_data|
  children = cat_data.delete(:children) || []
  parent = Category.find_or_create_by!(slug: cat_data[:slug]) do |c|
    c.assign_attributes(cat_data)
  end
  categories[parent.slug] = parent

  children.each do |child_data|
    child = Category.find_or_create_by!(slug: child_data[:slug]) do |c|
      c.assign_attributes(child_data.merge(parent: parent))
    end
    categories[child.slug] = child
  end
end
puts "  #{Category.count} categories created"

# ─── Products ─────────────────────────────────────────────────────────

products_data = [
  {
    name: "Titanium Hex Head Bolt NAS1352",
    sku: "AP-FST-001",
    part_number: "NAS1352-06-12",
    category_slug: "bolts",
    price_cents: 2450,
    stock_quantity: 250,
    mil_spec: "MIL-DTL-5541",
    material: "Titanium 6Al-4V",
    certification: "AS9100D",
    weight_kg: 0.028,
    temperature_min: -65,
    temperature_max: 600,
    featured: true,
    description: "Precision-machined hex head bolt manufactured from Ti-6Al-4V per AMS 4928. Cadmium plated per QQ-P-416, Type II, Class 1. Tensile strength: 160 KSI minimum. Passivated per AMS 2700.",
    specifications: {
      "Thread Size" => "6-32 UNF-3A",
      "Length" => "1.250 in",
      "Head Type" => "Hex Head",
      "Tensile Strength" => "160 KSI min",
      "Shear Strength" => "95 KSI min",
      "Finish" => "Cadmium Plate per QQ-P-416"
    }
  },
  {
    name: "A286 Self-Locking Nut MS21042",
    sku: "AP-FST-002",
    part_number: "MS21042-06",
    category_slug: "nuts",
    price_cents: 890,
    stock_quantity: 500,
    mil_spec: "MIL-DTL-25027",
    material: "A286 CRES",
    certification: "AS9100D",
    weight_kg: 0.012,
    temperature_min: -65,
    temperature_max: 1200,
    featured: true,
    description: "All-metal self-locking nut per MS21042. A286 corrosion-resistant steel per AMS 5737. Prevailing torque type with deformed thread segment. Reusable up to 15 installation/removal cycles.",
    specifications: {
      "Thread Size" => "6-32 UNF-3B",
      "Locking Type" => "Prevailing Torque",
      "Proof Load" => "2,140 lbs",
      "Hardness" => "HRC 26-36",
      "Cycles" => "15 reuses minimum"
    }
  },
  {
    name: "Cherry Max Blind Rivet CR3213",
    sku: "AP-FST-003",
    part_number: "CR3213-4-02",
    category_slug: "rivets",
    price_cents: 325,
    stock_quantity: 1000,
    mil_spec: "MIL-R-7885",
    material: "Alloy Steel / A286",
    certification: "FAA-PMA",
    weight_kg: 0.005,
    temperature_min: -65,
    temperature_max: 450,
    featured: false,
    description: "CherryMAX blind rivet for structural applications. Mechanically locked stem provides high shear and tensile strength. Installed from one side with standard CherryMAX pull tool.",
    specifications: {
      "Diameter" => "1/8 in (3.2mm)",
      "Grip Range" => "0.032 - 0.094 in",
      "Shear Strength" => "590 lbs min",
      "Tensile Strength" => "700 lbs min",
      "Head Style" => "100° Flush"
    }
  },
  {
    name: "Fluorocarbon O-Ring AS568-210",
    sku: "AP-SEL-001",
    part_number: "AS568-210-V75",
    category_slug: "o-rings",
    price_cents: 1850,
    stock_quantity: 150,
    mil_spec: "MIL-PRF-83248",
    material: "FKM Fluorocarbon (Viton)",
    certification: "AS9100D",
    weight_kg: 0.008,
    temperature_min: -15,
    temperature_max: 400,
    featured: true,
    description: "Aerospace-grade fluorocarbon O-ring per AS568 standard dimensions. Excellent resistance to Skydrol, JP-4, JP-5, and MIL-H-5606 hydraulic fluid. 75 Shore A durometer.",
    specifications: {
      "ID" => "0.796 in",
      "OD" => "1.004 in",
      "CS" => "0.103 in",
      "Durometer" => "75 Shore A",
      "Fluid Compatibility" => "Skydrol, JP-4/5, MIL-H-5606",
      "Compression Set" => "< 20% @ 200°F/70hr"
    }
  },
  {
    name: "Spiral Wound Gasket 304/Graphite",
    sku: "AP-SEL-002",
    part_number: "SWG-4-150-CG",
    category_slug: "gaskets",
    price_cents: 4500,
    stock_quantity: 75,
    mil_spec: "MIL-G-21032",
    material: "304 SS / Flexible Graphite",
    certification: "AS9100D",
    weight_kg: 0.340,
    temperature_min: -325,
    temperature_max: 850,
    featured: false,
    description: "Class 150 spiral wound gasket with 304 SS windings and flexible graphite filler. Carbon steel centering ring and 304 SS inner ring. ASME B16.20 dimensions.",
    specifications: {
      "Size" => "4 in (DN100)",
      "Pressure Class" => "150",
      "Winding" => "304 Stainless Steel",
      "Filler" => "Flexible Graphite",
      "Inner Ring" => "304 SS",
      "Outer Ring" => "Carbon Steel"
    }
  },
  {
    name: "ABEC-7 Angular Contact Bearing",
    sku: "AP-BRG-001",
    part_number: "7205-BEP-ABEC7",
    category_slug: "ball-bearings",
    price_cents: 18500,
    stock_quantity: 30,
    mil_spec: "MIL-B-17931",
    material: "52100 Chrome Steel",
    certification: "AS9100D",
    weight_kg: 0.085,
    temperature_min: -65,
    temperature_max: 300,
    featured: true,
    description: "Precision ABEC-7 angular contact ball bearing for flight control actuators and accessory gearbox applications. Pre-loaded matched pair available. Grease filled per MIL-PRF-81322.",
    specifications: {
      "Bore" => "25mm",
      "OD" => "52mm",
      "Width" => "15mm",
      "Contact Angle" => "25°",
      "Speed Rating" => "13,000 RPM",
      "Dynamic Load" => "15.9 kN"
    }
  },
  {
    name: "Self-Aligning Rod End MS21153",
    sku: "AP-BRG-002",
    part_number: "MS21153-DK8",
    category_slug: "rod-end-bearings",
    price_cents: 7850,
    stock_quantity: 45,
    mil_spec: "MIL-B-81820",
    material: "4340 Steel / PTFE Liner",
    certification: "FAA-PMA",
    weight_kg: 0.156,
    temperature_min: -65,
    temperature_max: 325,
    featured: false,
    description: "Military-spec self-aligning rod end bearing with PTFE fabric liner. Maintenance-free design for flight control linkages. Cadmium plated per QQ-P-416.",
    specifications: {
      "Bore" => "0.5000 in",
      "Thread" => "1/2-20 UNF-3A",
      "Misalignment" => "±12°",
      "Static Load" => "16,650 lbs",
      "Liner" => "PTFE Fabric",
      "Lubrication" => "Maintenance-Free"
    }
  },
  {
    name: "MIL-DTL-38999 Series III Connector",
    sku: "AP-AVI-001",
    part_number: "D38999/26WB35SN",
    category_slug: "connectors",
    price_cents: 28500,
    stock_quantity: 20,
    mil_spec: "MIL-DTL-38999",
    material: "Aluminum / Gold-Plated Contacts",
    certification: "QPL",
    weight_kg: 0.068,
    temperature_min: -65,
    temperature_max: 200,
    featured: true,
    description: "Series III circular connector with bayonet coupling. EMI/RFI shielding. Hermetically sealed. Cadmium plated aluminum shell with gold-plated copper alloy contacts. DO-160G qualified.",
    specifications: {
      "Shell Size" => "11",
      "Contacts" => "35 pins (size 22D)",
      "Coupling" => "Bayonet",
      "Plating" => "Cadmium (shell), Gold (contacts)",
      "Voltage" => "500 VDC",
      "Current" => "3A per contact"
    }
  },
  {
    name: "Tefzel MIL-W-22759/16 Wire",
    sku: "AP-AVI-002",
    part_number: "M22759/16-20-9",
    category_slug: "wire-cable",
    price_cents: 195,
    compare_at_price_cents: 250,
    stock_quantity: 5000,
    mil_spec: "MIL-W-22759/16",
    material: "Silver-Plated Copper / Tefzel",
    certification: "QPL",
    weight_kg: 0.003,
    temperature_min: -65,
    temperature_max: 302,
    featured: false,
    description: "Single conductor aircraft wire with ETFE (Tefzel) insulation. Silver-plated copper per ASTM B298. Lightweight, superior abrasion resistance. Priced per foot.",
    specifications: {
      "AWG" => "20",
      "Conductor" => "Silver-Plated Copper",
      "Insulation" => "ETFE (Tefzel)",
      "Voltage" => "600 VRMS",
      "Weight" => "4.5 lbs/1000ft",
      "Color" => "White"
    }
  },
  {
    name: "Carbon Fiber Pre-Preg AS4/3501-6",
    sku: "AP-CMP-001",
    part_number: "HMF-5322-12K-PW",
    category_slug: "composites",
    price_cents: 45000,
    stock_quantity: 15,
    mil_spec: "MIL-HDBK-17",
    material: "AS4 Carbon / 3501-6 Epoxy",
    certification: "AS9100D",
    weight_kg: 2.500,
    temperature_min: -65,
    temperature_max: 350,
    featured: true,
    description: "Aerospace-grade carbon fiber pre-preg. 12K tow plain weave fabric impregnated with 3501-6 epoxy resin. 350°F cure system. Priced per square meter.",
    specifications: {
      "Fiber" => "AS4 Carbon (12K tow)",
      "Resin" => "3501-6 Epoxy",
      "Weave" => "Plain Weave",
      "Areal Weight" => "370 g/m²",
      "Resin Content" => "42% by weight",
      "Cure Temp" => "350°F (177°C)"
    }
  },
  {
    name: "AN6227 Hydraulic Fitting",
    sku: "AP-HYD-001",
    part_number: "AN6227-6-6",
    category_slug: "hydraulic-fittings",
    price_cents: 3250,
    stock_quantity: 120,
    mil_spec: "MIL-DTL-18866",
    material: "4130 Alloy Steel",
    certification: "AS9100D",
    weight_kg: 0.045,
    temperature_min: -65,
    temperature_max: 450,
    featured: false,
    description: "Military-spec straight adapter fitting for 3000 PSI hydraulic systems. 37° JIC flare (AN) to MS33656 boss thread. Cadmium plated per QQ-P-416.",
    specifications: {
      "Size" => "-6 (3/8 in tube)",
      "Pressure" => "3,000 PSI working",
      "End 1" => "37° AN Flare",
      "End 2" => "MS33656 Boss",
      "Material" => "4130 Steel, Cadmium Plated",
      "Torque" => "200 in-lbs"
    }
  },
  {
    name: "PTFE-Lined Hydraulic Hose",
    sku: "AP-HYD-002",
    part_number: "AE701-6-36",
    category_slug: "hydraulic-hoses",
    price_cents: 12800,
    stock_quantity: 35,
    mil_spec: "MIL-DTL-27267",
    material: "PTFE / 304 SS Braid",
    certification: "AS9100D",
    weight_kg: 0.580,
    temperature_min: -65,
    temperature_max: 450,
    featured: false,
    description: "Medium-pressure PTFE-lined hose with 304 stainless steel braid. Compatible with Skydrol, phosphate ester, and MIL-H-5606 hydraulic fluids. 36 inches with pre-swaged end fittings.",
    specifications: {
      "Size" => "-6 (3/8 in)",
      "Length" => "36 in",
      "Working Pressure" => "3,000 PSI",
      "Burst Pressure" => "12,000 PSI",
      "Inner Tube" => "PTFE",
      "Braid" => "304 Stainless Steel"
    }
  },
  {
    name: "Inconel 718 12-Point Bolt",
    sku: "AP-FST-004",
    part_number: "NAS1953-08-16P",
    category_slug: "bolts",
    price_cents: 5600,
    stock_quantity: 80,
    mil_spec: "AMS 5662",
    material: "Inconel 718",
    certification: "AS9100D",
    weight_kg: 0.065,
    temperature_min: -423,
    temperature_max: 1200,
    featured: true,
    description: "High-temperature 12-point bolt manufactured from Inconel 718 per AMS 5662. Solution treated and aged. Passivated per AMS 2700. For turbine engine and hot section applications.",
    specifications: {
      "Thread Size" => "8-36 UNJF-3A",
      "Length" => "1.500 in",
      "Head Type" => "12-Point",
      "Tensile Strength" => "180 KSI min",
      "Hardness" => "HRC 36-44",
      "Finish" => "Passivated per AMS 2700"
    }
  },
  {
    name: "Aramid Honeycomb Core",
    sku: "AP-CMP-002",
    part_number: "HRH-10-3.0-48",
    category_slug: "composites",
    price_cents: 32000,
    stock_quantity: 8,
    mil_spec: "MIL-C-81986",
    material: "Aramid Fiber / Phenolic Resin",
    certification: "AS9100D",
    weight_kg: 4.200,
    temperature_min: -65,
    temperature_max: 350,
    featured: false,
    description: "Aramid fiber honeycomb core for sandwich panel construction. 3.0 pcf density, 1/8 cell size. Used in floor panels, fairings, and radomes. Sheet size: 48 x 96 inches.",
    specifications: {
      "Cell Size" => "1/8 in (3.2mm)",
      "Density" => "3.0 pcf",
      "Thickness" => "0.500 in",
      "Sheet Size" => "48 x 96 in",
      "Crush Strength" => "350 PSI",
      "Shear Strength" => "175 PSI (L), 100 PSI (W)"
    }
  },
  {
    name: "Hi-Lok Collar HL70",
    sku: "AP-FST-005",
    part_number: "HL70-6",
    category_slug: "rivets",
    price_cents: 185,
    compare_at_price_cents: 225,
    stock_quantity: 3,
    mil_spec: "MIL-STD-403",
    material: "2024-T4 Aluminum",
    certification: "FAA-PMA",
    weight_kg: 0.002,
    temperature_min: -65,
    temperature_max: 250,
    featured: false,
    description: "Hi-Lok collar for use with Hi-Lok and Hi-Tigue pins. Controlled preload through torque-off wrenching element. 2024-T4 aluminum for galvanic compatibility with aluminum structures.",
    specifications: {
      "Size" => "3/16 in",
      "Material" => "2024-T4 Aluminum",
      "Compatible Pins" => "HL10, HL11, HL70V",
      "Preload" => "1,600 lbs nominal",
      "Torque-Off" => "Self-limiting"
    }
  }
]

products_data.each do |data|
  cat_slug = data.delete(:category_slug)
  category = categories[cat_slug]
  next unless category

  Product.find_or_create_by!(sku: data[:sku]) do |p|
    p.assign_attributes(data.merge(category: category))
  end
end
puts "  #{Product.count} products created"

# ─── Sample Address ───────────────────────────────────────────────────

Address.find_or_create_by!(user: customer, line1: "1200 Aviation Blvd") do |a|
  a.address_type = "shipping"
  a.name = "James Mitchell"
  a.city = "Wichita"
  a.state = "KS"
  a.postal_code = "67209"
  a.country = "US"
end

puts "Done! AeroParts Pro is ready."
puts ""
puts "  Admin login: admin@aeroparts.pro / password123"
puts "  Customer login: pilot@example.com / password123"
puts ""
puts "  Run: bin/dev"
