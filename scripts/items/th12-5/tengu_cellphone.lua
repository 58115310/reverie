local Screen = CuerLib.Screen;
local Inputs = CuerLib.Inputs;
local SaveAndLoad = CuerLib.SaveAndLoad;
local Detection = CuerLib.Detection;
local HoldingActive = CuerLib.HoldingActive;
local Cellphone = ModItem("Tengu Cellphone", "HatateCellphone");

local itemConfig = Isaac.GetItemConfig();
local itemPools = THI.Game:GetItemPool();

local priceFont = Font();
priceFont:Load("font/terminus8.fnt");

local SelectionSprite = Sprite();

SelectionSprite:Load("gfx/ui/select_frame.anm2", true);
SelectionSprite:Play("Frame");

local WebsiteSprite = Sprite();
WebsiteSprite:Load("gfx/ui/ayazun.anm2", true);
WebsiteSprite:Play("Ayazun");
local maxContentCount = 3;

local PurchaseStrings = {
    Title = "#CELLPHONE_PURCHASE_TITLE",
    Desc = "#CELLPHONE_PURCHASE_DESCRIPTION"
}

local CardKind = {
    REGULAR = 1,
    SUIT = 1 << 1,
    RUNE = 1 << 2,
}

local QualityPrices = {
    [0] = 5,
    [1] = 10,
    [2] = 15,
    [3] = 20,
    [4] = 30,
}

local DefaultSprites = {
    -- [PickupVariant.PICKUP_HEART] = "gfx/005.011_heart.anm2",
    -- [PickupVariant.PICKUP_KEY] = "gfx/005.031_key.anm2",
    -- [PickupVariant.PICKUP_BOMB] = "gfx/005.041_bomb.anm2",
    -- [PickupVariant.PICKUP_LIL_BATTERY] = "gfx/005.090_littlebattery.anm2",
    -- [PickupVariant.PICKUP_GRAB_BAG] = "gfx/005.069_grabbag.anm2",
    -- [PickupVariant.PICKUP_TAROTCARD] = "gfx/005.301_tarot card.anm2",
    -- [PickupVariant.PICKUP_PILL] = "gfx/005.071_pill blue-blue.anm2",
}
local Sprites = {
    [PickupVariant.PICKUP_HEART] = { -- Heart
        [HeartSubType.HEART_FULL] = "gfx/005.011_heart.anm2", -- Red Heart
        [HeartSubType.HEART_HALF] = "gfx/005.012_heart (half).anm2", -- Half Red Heart
        [HeartSubType.HEART_SOUL] = "gfx/005.013_heart (soul).anm2", -- Soul Heart
        [HeartSubType.HEART_HALF_SOUL] = "gfx/005.018_heart (halfsoul).anm2", -- Half Soul Heart
        [HeartSubType.HEART_BLACK] = "gfx/005.016_black heart.anm2", -- Black Heart
        [HeartSubType.HEART_ETERNAL] = "gfx/005.014_heart (eternal).anm2", -- Eternal Heart
        [HeartSubType.HEART_BLENDED] = "gfx/005.019_blended heart.anm2", -- Blended Heart
        [HeartSubType.HEART_BONE] = "gfx/005.01a_bone heart.anm2", -- Bone Heart
        [HeartSubType.HEART_DOUBLEPACK] = "gfx/005.015_double heart.anm2", -- Double Heart
        [HeartSubType.HEART_GOLDEN] = "gfx/005.017_goldheart.anm2", -- Golden Heart
        [HeartSubType.HEART_ROTTEN] = "gfx/005.01b_rotten heart.anm2", -- Rotten Heart
        [HeartSubType.HEART_SCARED] = "gfx/005.020_scared heart.anm2", -- Scared Heart
    },
    [PickupVariant.PICKUP_KEY] = { -- Key
        [KeySubType.KEY_NORMAL] = "gfx/005.031_key.anm2", -- Key
        [KeySubType.KEY_CHARGED] = "gfx/005.034_chargedkey.anm2", -- Charged Key
        [KeySubType.KEY_DOUBLEPACK] = "gfx/005.033_keyring.anm2", -- Double Key
        [KeySubType.KEY_GOLDEN] = "gfx/005.032_golden key.anm2", -- Golden Key
    },
    [PickupVariant.PICKUP_BOMB] = { -- Bomb
        [BombSubType.BOMB_NORMAL] = "gfx/005.041_bomb.anm2", -- Bomb
        [BombSubType.BOMB_DOUBLEPACK] = "gfx/005.042_double bomb.anm2", -- Double Bomb
        [BombSubType.BOMB_GIGA] = "gfx/005.047_giga bomb.anm2", -- Giga Bomb
        [BombSubType.BOMB_GOLDEN] = "gfx/005.043_golden bomb.anm2", -- Golden Bomb
    },
    [PickupVariant.PICKUP_LIL_BATTERY] = { -- Battery
        [BatterySubType.BATTERY_NORMAL] = "gfx/005.090_littlebattery.anm2", -- Normal
        [BatterySubType.BATTERY_MICRO] = "gfx/005.090_microbattery.anm2", -- Micro
        [BatterySubType.BATTERY_MEGA] = "gfx/005.090_megabattery.anm2", -- Mega
        [BatterySubType.BATTERY_GOLDEN] = "gfx/005.090_golden battery.anm2", -- Golden
    },
    [PickupVariant.PICKUP_GRAB_BAG] = { -- Sack
        [SackSubType.SACK_NORMAL] = "gfx/005.069_grabbag.anm2", -- Normal
        [SackSubType.SACK_BLACK] = "gfx/005.069_black sack.anm2", -- Black
    },
    [PickupVariant.PICKUP_TAROTCARD] = { -- Cards and Runes
        [Card.CARD_FOOL] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_MAGICIAN] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_HIGH_PRIESTESS] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_EMPRESS] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_EMPEROR] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_HIEROPHANT] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_LOVERS] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_CHARIOT] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_JUSTICE] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_HERMIT] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_WHEEL_OF_FORTUNE] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_STRENGTH] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_HANGED_MAN] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_DEATH] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_TEMPERANCE] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_DEVIL] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_TOWER] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_STARS] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_MOON] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_SUN] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_JUDGEMENT] = "gfx/005.301_tarot card.anm2",
        [Card.CARD_WORLD] = "gfx/005.301_tarot card.anm2",
        -- Suit Cards
        [Card.CARD_CLUBS_2] ="gfx/005.302_suit card.anm2",
        [Card.CARD_DIAMONDS_2] ="gfx/005.302_suit card.anm2",
        [Card.CARD_SPADES_2] ="gfx/005.302_suit card.anm2",
        [Card.CARD_HEARTS_2] ="gfx/005.302_suit card.anm2",
        [Card.CARD_ACE_OF_CLUBS] ="gfx/005.302_suit card.anm2",
        [Card.CARD_ACE_OF_DIAMONDS] ="gfx/005.302_suit card.anm2",
        [Card.CARD_ACE_OF_SPADES] ="gfx/005.302_suit card.anm2",
        [Card.CARD_ACE_OF_HEARTS] ="gfx/005.302_suit card.anm2",
        [Card.CARD_JOKER] ="gfx/005.302_suit card.anm2",
        [Card.CARD_RULES] = "gfx/005.302_suit card.anm2",
        [Card.CARD_SUICIDE_KING] = "gfx/005.302_suit card.anm2",
        [Card.CARD_QUESTIONMARK] = "gfx/005.302_suit card.anm2",
        [Card.CARD_QUEEN_OF_HEARTS] = "gfx/005.302_suit card.anm2",

        -- Rune1
        [Card.RUNE_HAGALAZ] = "gfx/005.303_rune1.anm2",
        [Card.RUNE_JERA] = "gfx/005.303_rune1.anm2",
        [Card.RUNE_EHWAZ] = "gfx/005.303_rune1.anm2",
        [Card.RUNE_DAGAZ] = "gfx/005.303_rune1.anm2",

        -- Rune2
        [Card.RUNE_ANSUZ] = "gfx/005.304_rune2.anm2",
        [Card.RUNE_PERTHRO] = "gfx/005.304_rune2.anm2",
        [Card.RUNE_BERKANO] = "gfx/005.304_rune2.anm2",
        [Card.RUNE_ALGIZ] = "gfx/005.304_rune2.anm2",
        [Card.RUNE_BLANK] = "gfx/005.304_rune2.anm2",

        -- Black Rune
        [Card.RUNE_BLACK] = "gfx/005.307_blackrune.anm2",

        -- MTG Cards
        [Card.CARD_CHAOS] = "gfx/005.308_magic card.anm2",
        [Card.CARD_HUGE_GROWTH] = "gfx/005.308_magic card.anm2",
        [Card.CARD_ANCIENT_RECALL] = "gfx/005.308_magic card.anm2",
        [Card.CARD_ERA_WALK] = "gfx/005.308_magic card.anm2",

        -- Misc cards
        [Card.CARD_CREDIT] = "gfx/005.310_credit card.anm2",
        [Card.CARD_HUMANITY] = "gfx/005.309_card against humanity.anm2",
        [Card.CARD_GET_OUT_OF_JAIL] = "gfx/005.312_chance card.anm2",
        [Card.CARD_DICE_SHARD] = "gfx/005.306_diceshard.anm2",
        [Card.CARD_EMERGENCY_CONTACT] = "gfx/005.305_emergencycontact.anm2",
        [Card.CARD_HOLY] = "gfx/005.311_holy card.anm2",
        [Card.CARD_CRACKED_KEY] = "gfx/005.300.15_cracked key.anm2",
        [Card.RUNE_SHARD] = "gfx/005.313_rune shard.anm2",
        [Card.CARD_WILD] = "gfx/005.300.17_unus card.anm2",
        
        -- Reversed tarots
        [Card.CARD_REVERSE_FOOL] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_MAGICIAN] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_HIGH_PRIESTESS] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_EMPRESS] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_EMPEROR] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_HIEROPHANT] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_LOVERS] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_CHARIOT] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_JUSTICE] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_HERMIT] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_STRENGTH] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_HANGED_MAN] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_DEATH] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_TEMPERANCE] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_DEVIL] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_TOWER] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_STARS] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_MOON] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_SUN] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_JUDGEMENT] = "gfx/005.300.14_reverse tarot card.anm2",
        [Card.CARD_REVERSE_WORLD] = "gfx/005.300.14_reverse tarot card.anm2",

        [Card.CARD_SOUL_ISAAC] = "gfx/005.300.18_soul of isaac.anm2",
        [Card.CARD_SOUL_MAGDALENE] = "gfx/005.300.19_soul of magdalene.anm2",
        [Card.CARD_SOUL_CAIN] = "gfx/005.300.20_soul of cain.anm2",
        [Card.CARD_SOUL_JUDAS] = "gfx/005.300.21_soul of judas.anm2",
        [Card.CARD_SOUL_BLUEBABY] = "gfx/005.300.22_soul of blue baby.anm2",
        [Card.CARD_SOUL_EVE] = "gfx/005.300.23_soul of eve.anm2",
        [Card.CARD_SOUL_SAMSON] = "gfx/005.300.24_soul of samson.anm2",
        [Card.CARD_SOUL_AZAZEL] = "gfx/005.300.25_soul of azazel.anm2",
        [Card.CARD_SOUL_LAZARUS] = "gfx/005.300.26_soul of lazarus.anm2",
        [Card.CARD_SOUL_EDEN] = "gfx/005.300.27_soul of eden.anm2",
        [Card.CARD_SOUL_LOST] = "gfx/005.300.28_soul of the lost.anm2",
        [Card.CARD_SOUL_LILITH] = "gfx/005.300.29_soul of lilith.anm2",
        [Card.CARD_SOUL_KEEPER] = "gfx/005.300.30_soul of the keeper.anm2",
        [Card.CARD_SOUL_APOLLYON] = "gfx/005.300.31_soul of apollyon.anm2",
        [Card.CARD_SOUL_FORGOTTEN] = "gfx/005.300.32_soul of the forgotten.anm2",
        [Card.CARD_SOUL_BETHANY] = "gfx/005.300.33_soul of bethany.anm2",
        [Card.CARD_SOUL_JACOB] = "gfx/005.300.34_soul of jacob.anm2",
    },
    [PickupVariant.PICKUP_PILL] = { -- Pills
        [PillColor.PILL_BLUE_BLUE] = "gfx/005.071_pill blue-blue.anm2",
	    [PillColor.PILL_WHITE_BLUE] = "gfx/005.072_pill white-blue.anm2",
	    [PillColor.PILL_ORANGE_ORANGE] = "gfx/005.073_pill orange-orange.anm2",
	    [PillColor.PILL_WHITE_WHITE] = "gfx/005.074_pill white-white.anm2",
	    [PillColor.PILL_REDDOTS_RED] = "gfx/005.075_pill dots-red.anm2",
	    [PillColor.PILL_PINK_RED] = "gfx/005.076_pill pink-red.anm2",
	    [PillColor.PILL_BLUE_CADETBLUE] = "gfx/005.077_pill blue-cadetblue.anm2",
	    [PillColor.PILL_YELLOW_ORANGE] = "gfx/005.078_pill yellow-orange.anm2",
	    [PillColor.PILL_ORANGEDOTS_WHITE] = "gfx/005.079_pill dots-white.anm2",
	    [PillColor.PILL_WHITE_AZURE] = "gfx/005.080_pill white-azure.anm2",
	    [PillColor.PILL_BLACK_YELLOW] = "gfx/005.081_pill black-yellow.anm2",
	    [PillColor.PILL_WHITE_BLACK] = "gfx/005.082_pill white-black.anm2",
	    [PillColor.PILL_WHITE_YELLOW] = "gfx/005.083_pill white-yellow.anm2",
	    [PillColor.PILL_GOLD] = "gfx/005.084_pill gold-gold.anm2",

        
        [PillColor.PILL_BLUE_BLUE | PillColor.PILL_GIANT_FLAG] = "gfx/005.071_horse pill blue-blue.anm2",
	    [PillColor.PILL_WHITE_BLUE | PillColor.PILL_GIANT_FLAG] = "gfx/005.072_horse pill white-blue.anm2",
	    [PillColor.PILL_ORANGE_ORANGE | PillColor.PILL_GIANT_FLAG] = "gfx/005.073_horse pill orange-orange.anm2",
	    [PillColor.PILL_WHITE_WHITE | PillColor.PILL_GIANT_FLAG] = "gfx/005.074_horse pill white-white.anm2",
	    [PillColor.PILL_REDDOTS_RED | PillColor.PILL_GIANT_FLAG] = "gfx/005.075_horse pill dots-red.anm2",
	    [PillColor.PILL_PINK_RED | PillColor.PILL_GIANT_FLAG] = "gfx/005.076_horse pill pink-red.anm2",
	    [PillColor.PILL_BLUE_CADETBLUE | PillColor.PILL_GIANT_FLAG] = "gfx/005.077_horse pill blue-cadetblue.anm2",
	    [PillColor.PILL_YELLOW_ORANGE | PillColor.PILL_GIANT_FLAG] = "gfx/005.078_horse pill yellow-orange.anm2",
	    [PillColor.PILL_ORANGEDOTS_WHITE | PillColor.PILL_GIANT_FLAG] = "gfx/005.079_horse pill dots-white.anm2",
	    [PillColor.PILL_WHITE_AZURE | PillColor.PILL_GIANT_FLAG] = "gfx/005.080_horse pill white-azure.anm2",
	    [PillColor.PILL_BLACK_YELLOW | PillColor.PILL_GIANT_FLAG] = "gfx/005.081_horse pill black-yellow.anm2",
	    [PillColor.PILL_WHITE_BLACK | PillColor.PILL_GIANT_FLAG] = "gfx/005.082_horse pill white-black.anm2",
	    [PillColor.PILL_WHITE_YELLOW | PillColor.PILL_GIANT_FLAG] = "gfx/005.083_horse pill white-yellow.anm2",
	    [PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG] = "gfx/005.084_horse pill gold-gold.anm2",
    }
}

local Prices = {
    [PickupVariant.PICKUP_HEART] = { -- Heart
        [HeartSubType.HEART_FULL] = 3, -- Red Heart
        [HeartSubType.HEART_HALF] = 1, -- Half Red Heart
        [HeartSubType.HEART_SOUL] = 5, -- Soul Heart
        [HeartSubType.HEART_ETERNAL] = 5, -- Eternal Heart
        [HeartSubType.HEART_DOUBLEPACK] = 5, -- Double Heart
        [HeartSubType.HEART_BLACK] = 5, -- Black Heart
        [HeartSubType.HEART_GOLDEN] = 5, -- Golden Heart
        [HeartSubType.HEART_HALF_SOUL] = 3, -- Half Soul Heart
        [HeartSubType.HEART_SCARED] = 3, -- Scared Heart
        [HeartSubType.HEART_BLENDED] = 5, -- Blended Heart
        [HeartSubType.HEART_BONE] = 5, -- Bone Heart
        [HeartSubType.HEART_ROTTEN] = 1, -- Rotten Heart
    },
    [PickupVariant.PICKUP_KEY] = { -- Key
        [KeySubType.KEY_NORMAL] = 5, -- Key
        [KeySubType.KEY_GOLDEN] = 10, -- Golden Key
        [KeySubType.KEY_DOUBLEPACK] = 8, -- Double Key
        [KeySubType.KEY_CHARGED] = 6, -- Charged Key
    },
    [PickupVariant.PICKUP_BOMB] = { -- Bomb
        [BombSubType.BOMB_NORMAL] = 5, -- Bomb
        [BombSubType.BOMB_DOUBLEPACK] = 8, -- Double Bomb
        [BombSubType.BOMB_GOLDEN] = 10, -- Golden Bomb
        [BombSubType.BOMB_GIGA] = 10, -- Giga Bomb
    },
    [PickupVariant.PICKUP_LIL_BATTERY] = { -- Battery
        [BatterySubType.BATTERY_NORMAL] = 5, -- Normal
        [BatterySubType.BATTERY_MICRO] = 3, -- Micro
        [BatterySubType.BATTERY_MEGA] = 8, -- Mega
        [BatterySubType.BATTERY_GOLDEN] = 10, -- Golden
    },
    [PickupVariant.PICKUP_GRAB_BAG] = { -- Sack
        [SackSubType.SACK_NORMAL] = 7, -- Normal
        [SackSubType.SACK_BLACK] = 7, -- Black
    },
    [PickupVariant.PICKUP_TAROTCARD] = { -- Cards and Runes
        [Card.CARD_FOOL] = 5,
        [Card.CARD_MAGICIAN] = 5,
        [Card.CARD_HIGH_PRIESTESS] = 5,
        [Card.CARD_EMPRESS] = 5,
        [Card.CARD_EMPEROR] = 5,
        [Card.CARD_HIEROPHANT] = 5,
        [Card.CARD_LOVERS] = 5,
        [Card.CARD_CHARIOT] = 5,
        [Card.CARD_JUSTICE] = 5,
        [Card.CARD_HERMIT] = 5,
        [Card.CARD_WHEEL_OF_FORTUNE] = 5,
        [Card.CARD_STRENGTH] = 5,
        [Card.CARD_HANGED_MAN] = 5,
        [Card.CARD_DEATH] = 5,
        [Card.CARD_TEMPERANCE] = 5,
        [Card.CARD_DEVIL] = 5,
        [Card.CARD_TOWER] = 5,
        [Card.CARD_STARS] = 5,
        [Card.CARD_MOON] = 5,
        [Card.CARD_SUN] = 5,
        [Card.CARD_JUDGEMENT] = 5,
        [Card.CARD_WORLD] = 5,
        -- Suit Cards
        [Card.CARD_CLUBS_2] =5,
        [Card.CARD_DIAMONDS_2] =5,
        [Card.CARD_SPADES_2] =5,
        [Card.CARD_HEARTS_2] =5,
        [Card.CARD_ACE_OF_CLUBS] =5,
        [Card.CARD_ACE_OF_DIAMONDS] =5,
        [Card.CARD_ACE_OF_SPADES] =5,
        [Card.CARD_ACE_OF_HEARTS] =5,
        [Card.CARD_JOKER] =5,
        [Card.CARD_RULES] = 5,
        [Card.CARD_SUICIDE_KING] = 5,
        [Card.CARD_QUESTIONMARK] = 5,
        [Card.CARD_QUEEN_OF_HEARTS] = 5,

        -- Rune1
        [Card.RUNE_HAGALAZ] = 5,
        [Card.RUNE_JERA] = 5,
        [Card.RUNE_EHWAZ] = 5,
        [Card.RUNE_DAGAZ] = 5,

        -- Rune2
        [Card.RUNE_ANSUZ] = 5,
        [Card.RUNE_PERTHRO] = 5,
        [Card.RUNE_BERKANO] = 5,
        [Card.RUNE_ALGIZ] = 5,
        [Card.RUNE_BLANK] = 5,

        -- Black Rune
        [Card.RUNE_BLACK] = 5,

        -- MTG Cards
        [Card.CARD_CHAOS] = 5,
        [Card.CARD_HUGE_GROWTH] = 5,
        [Card.CARD_ANCIENT_RECALL] = 5,
        [Card.CARD_ERA_WALK] = 5,

        -- Misc cards
        [Card.CARD_CREDIT] = 5,
        [Card.CARD_HUMANITY] = 5,
        [Card.CARD_GET_OUT_OF_JAIL] = 5,
        [Card.CARD_DICE_SHARD] = 5,
        [Card.CARD_EMERGENCY_CONTACT] = 5,
        [Card.CARD_HOLY] = 5,
        [Card.CARD_CRACKED_KEY] = 5,
        [Card.RUNE_SHARD] = 5,
        [Card.CARD_WILD] = 5,
        
        -- Reversed tarots
        [Card.CARD_REVERSE_FOOL] = 5,
        [Card.CARD_REVERSE_MAGICIAN] = 5,
        [Card.CARD_REVERSE_HIGH_PRIESTESS] = 5,
        [Card.CARD_REVERSE_EMPRESS] = 5,
        [Card.CARD_REVERSE_EMPEROR] = 5,
        [Card.CARD_REVERSE_HIEROPHANT] = 5,
        [Card.CARD_REVERSE_LOVERS] = 5,
        [Card.CARD_REVERSE_CHARIOT] = 5,
        [Card.CARD_REVERSE_JUSTICE] = 5,
        [Card.CARD_REVERSE_HERMIT] = 5,
        [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = 5,
        [Card.CARD_REVERSE_STRENGTH] = 5,
        [Card.CARD_REVERSE_HANGED_MAN] = 5,
        [Card.CARD_REVERSE_DEATH] = 5,
        [Card.CARD_REVERSE_TEMPERANCE] = 5,
        [Card.CARD_REVERSE_DEVIL] = 5,
        [Card.CARD_REVERSE_TOWER] = 5,
        [Card.CARD_REVERSE_STARS] = 5,
        [Card.CARD_REVERSE_MOON] = 5,
        [Card.CARD_REVERSE_SUN] = 5,
        [Card.CARD_REVERSE_JUDGEMENT] = 5,
        [Card.CARD_REVERSE_WORLD] = 5,

        [Card.CARD_SOUL_ISAAC] = 5,
        [Card.CARD_SOUL_MAGDALENE] = 5,
        [Card.CARD_SOUL_CAIN] = 5,
        [Card.CARD_SOUL_JUDAS] = 5,
        [Card.CARD_SOUL_BLUEBABY] = 5,
        [Card.CARD_SOUL_EVE] = 5,
        [Card.CARD_SOUL_SAMSON] = 5,
        [Card.CARD_SOUL_AZAZEL] = 5,
        [Card.CARD_SOUL_LAZARUS] = 5,
        [Card.CARD_SOUL_EDEN] = 5,
        [Card.CARD_SOUL_LOST] = 5,
        [Card.CARD_SOUL_LILITH] = 5,
        [Card.CARD_SOUL_KEEPER] = 5,
        [Card.CARD_SOUL_APOLLYON] = 5,
        [Card.CARD_SOUL_FORGOTTEN] = 5,
        [Card.CARD_SOUL_BETHANY] = 5,
        [Card.CARD_SOUL_JACOB] = 5,
    },
    [PickupVariant.PICKUP_PILL] = { -- Pills
        [PillColor.PILL_BLUE_BLUE] = 5,
	    [PillColor.PILL_WHITE_BLUE] = 5,
	    [PillColor.PILL_ORANGE_ORANGE] = 5,
	    [PillColor.PILL_WHITE_WHITE] = 5,
	    [PillColor.PILL_REDDOTS_RED] = 5,
	    [PillColor.PILL_PINK_RED] = 5,
	    [PillColor.PILL_BLUE_CADETBLUE] = 5,
	    [PillColor.PILL_YELLOW_ORANGE] = 5,
	    [PillColor.PILL_ORANGEDOTS_WHITE] = 5,
	    [PillColor.PILL_WHITE_AZURE] = 5,
	    [PillColor.PILL_BLACK_YELLOW] = 5,
	    [PillColor.PILL_WHITE_BLACK] = 5,
	    [PillColor.PILL_WHITE_YELLOW] = 5,
	    [PillColor.PILL_GOLD] = 5,

        
        [PillColor.PILL_BLUE_BLUE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_WHITE_BLUE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_ORANGE_ORANGE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_WHITE_WHITE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_REDDOTS_RED | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_PINK_RED | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_BLUE_CADETBLUE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_YELLOW_ORANGE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_ORANGEDOTS_WHITE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_WHITE_AZURE | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_BLACK_YELLOW | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_WHITE_BLACK | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_WHITE_YELLOW | PillColor.PILL_GIANT_FLAG] = 5,
	    [PillColor.PILL_GOLD | PillColor.PILL_GIANT_FLAG] = 5,
    }
}

local RoomPools = {
    [RoomType.ROOM_DEFAULT] = {
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
    },
    [RoomType.ROOM_TREASURE] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_GOLDEN, Weight = 0.2 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_GOLDEN, Weight = 0.2 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1 },
    },
    [RoomType.ROOM_SHOP] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_LIL_BATTERY, SubType = BatterySubType.BATTERY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_GRAB_BAG, SubType = SackSubType.SACK_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TRINKET, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1 },
    },
    [RoomType.ROOM_ERROR] = {
        { Variant = PickupVariant.PICKUP_BOMB, SubType = 0, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = 0, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = 0, Weight = 1 },
        { Variant = PickupVariant.PICKUP_LIL_BATTERY, SubType = 0, Weight = 1 },
        { Variant = PickupVariant.PICKUP_GRAB_BAG, SubType = 0, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TRINKET, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.NUM_ITEMPOOLS, Weight = 5 },
    },
    [RoomType.ROOM_BOSS] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 1 },
    },
    [RoomType.ROOM_MINIBOSS] = {
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 1 },
    },
    [RoomType.ROOM_SECRET] = {
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 0.5},
    },
    [RoomType.ROOM_SUPERSECRET] = {
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = 0, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1},
    },
    [RoomType.ROOM_ARCADE] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.NUM_ITEMPOOLS}
        },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Kind = CardKind.REGULAR | CardKind.SUIT, Weight = 0.4 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.NUM_ITEMPOOLS, Weight = 1},
    },
    [RoomType.ROOM_CURSE] = {
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_BLACK, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_GRAB_BAG, SubType = SackSubType.SACK_BLACK, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 0.6},
    },
    [RoomType.ROOM_CHALLENGE] = {
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TRINKET, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 1 },
        { Variant = PickupVariant.PICKUP_LIL_BATTERY, SubType = BatterySubType.BATTERY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_BOSS, Weight = 2},
    },
    [RoomType.ROOM_LIBRARY] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL}
        },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_LIL_BATTERY, SubType = BatterySubType.BATTERY_NORMAL, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1}
    },
    [RoomType.ROOM_SACRIFICE] = {
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_ETERNAL, Weight = 0.5 },
        --{ Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_ANGEL, Weight = 0.2}
    },
    [RoomType.ROOM_DEVIL] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_BLACK, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_GRAB_BAG, SubType = SackSubType.SACK_BLACK, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1}
    },
    [RoomType.ROOM_ANGEL] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_ETERNAL, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1}
    },
    [RoomType.ROOM_DUNGEON] = {
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 0.5 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1}
    },
    [RoomType.ROOM_BOSSRUSH] = {
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1}
    },
    [RoomType.ROOM_ISAACS] = {
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_FULL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, SubType = HeartSubType.HEART_SOUL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_PILL, Weight = 1 },
    },
    [RoomType.ROOM_BARREN] = {
        { Variant = PickupVariant.PICKUP_PILL, Weight = 1 }
    },
    [RoomType.ROOM_CHEST] = {
        { Variant = PickupVariant.PICKUP_BOMB, SubType = BombSubType.BOMB_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_KEY, SubType = KeySubType.KEY_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_GRAB_BAG, SubType = SackSubType.SACK_NORMAL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 1 },
        { Variant = PickupVariant.PICKUP_PILL, Weight = 1 },
        { Variant = PickupVariant.PICKUP_HEART, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL, Weight = 1}
    },
    [RoomType.ROOM_DICE] = {
        { Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Card.CARD_DICE_SHARD, Weight = 1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D6, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D4, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D7, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D8, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D10, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D12, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D20, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_D100, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_ETERNAL_D6, Weight = 0.1 },
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, SubType = CollectibleType.COLLECTIBLE_SPINDOWN_DICE, Weight = 0.1 },
    },
    [RoomType.ROOM_BLACK_MARKET] = {
        { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_SHOP, Weight = 1 },
    },
    [RoomType.ROOM_PLANETARIUM] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_TAROTCARD, Weight = 1 },
    },
    [RoomType.ROOM_ULTRASECRET] = {
        Always = {
            { Variant = PickupVariant.PICKUP_COLLECTIBLE, ItemPool = ItemPoolType.POOL_NULL},
        },
        { Variant = PickupVariant.PICKUP_TAROTCARD, SubType = Card.CARD_CRACKED_KEY, Weight = 1 },
    },
}


local function IsPurchasing(player)
    return HoldingActive:GetHoldingItem(player) == Cellphone.Item;
end
function Cellphone.GetAyazunData(init)
    return Cellphone:GetGlobalData(init, function() return {
        Purchased = {}
    }end)
end
local Offers = {};
function Cellphone.GetAyazunContent(init)
    return Offers;
end

function Cellphone.ClearAyazunContent()
    local contents = Cellphone.GetAyazunContent(true);
    for i = 1, #contents do
        table.remove(contents, 1);
    end
end

function Cellphone.GetPlayerTempData(player, init)
    local data = player:GetData()
    if (init) then
        data._HATATE_CELLPHONE = data._HATATE_CELLPHONE or {
            Selection = 0
        };
    end
    return data._HATATE_CELLPHONE;
end
function Cellphone.GetItemSpritePath(variant, subType)
    local variantData = Sprites[variant];
    if (variantData) then
        local path = variantData[subType];
        if (path ~= nil) then
            return path;
        end
    end
    if (DefaultSprites[variant]) then
        return DefaultSprites[variant];
    end
    return "";
end
function Cellphone.GetCollectibleGfx(subType)
    local col = itemConfig:GetCollectible(subType);
    if (col) then
        return col.GfxFileName or "";
    end
    return "";
end
function Cellphone.GetTrinketGfx(subType)
    local col = itemConfig:GetTrinket(subType);
    if (col) then
        return col.GfxFileName or "";
    end
    return "";
end
function Cellphone.GetItemPrice(variant, subType)
    if (variant == PickupVariant.PICKUP_COLLECTIBLE) then

        local col = itemConfig:GetCollectible(subType);
        if (col) then
            return QualityPrices[col.Quality];
        end
        return 20;
    end

    local variantData = Prices[variant];
    if (variantData) then
        local price = variantData[subType];
        if (price ~= nil) then
            return price + 2;
        end
    end
    return 7;
end

function Cellphone.GetRandomPickupSubType(variant, seed, cardKind)
    if (variant == PickupVariant.PICKUP_TAROTCARD) then
        if (cardKind) then
            if (cardKind == CardKind.RUNE) then
                return itemPools:GetCard(seed, false, false, true);
            else
                local rune = false;
                local playCard = false;
                if (cardKind & CardKind.RUNE > 0) then
                    rune = true;
                end
                if (cardKind & CardKind.SUIT > 0) then
                    playCard = true;
                end
                return itemPools:GetCard(seed, playCard, rune, false);
            end
        end
        return itemPools:GetCard(seed, true, true, false);
    elseif (variant == PickupVariant.PICKUP_PILL) then
        return itemPools:GetPill(seed);
    else
        local variantData = Prices[variant];
        if (variantData and #variantData > 0) then
            return seed % #variantData + 1;
        end    
        return 1;
    end
end

function Cellphone.GetOfferData(itemInfo, seed, hidden)
    local variant = itemInfo.Variant;
    local subType = itemInfo.SubType or 0;
    local itemPool = itemInfo.ItemPool;
    
    if (itemPool == nil or itemPool == ItemPoolType.POOL_NULL) then
        local room = THI.Game:GetRoom();
        itemPool = itemPools:GetPoolForRoom (room:GetType(), seed);
    end

    if (itemPool == ItemPoolType.NUM_ITEMPOOLS) then
        itemPool = seed % (ItemPoolType.NUM_ITEMPOOLS - 1) + 1;
    end

    if (itemPool < 0 ) then
        itemPool = ItemPoolType.POOL_TREASURE;
    end
    local sprite = Sprite();
    if (variant == PickupVariant.PICKUP_COLLECTIBLE) then

        if (not itemConfig:GetCollectible(subType)) then
            subType = itemPools:GetCollectible (itemPool, false, seed, CollectibleType.COLLECTIBLE_BREAKFAST);
            itemPools:AddRoomBlacklist(subType);
        end
        sprite:Load("gfx/005.100_collectible.anm2", false);
        sprite:ReplaceSpritesheet(1, Cellphone.GetCollectibleGfx(subType));
        sprite:LoadGraphics();
        sprite:Play("ShopIdle")
    elseif (variant == PickupVariant.PICKUP_TRINKET) then

        if (not itemConfig:GetTrinket(subType)) then
            subType = itemPools:GetTrinket(true);
        end
        sprite:Load("gfx/005.350_trinket.anm2", false);
        sprite:ReplaceSpritesheet(0, Cellphone.GetTrinketGfx(subType));
        sprite:LoadGraphics();
        sprite:Play("Idle");
    else
        if (subType == nil or subType <= 0) then
            subType = Cellphone.GetRandomPickupSubType(variant, seed, itemInfo.Kind);
        end
        local path = Cellphone.GetItemSpritePath(variant, subType);
        sprite:Load(path, true);
        sprite:Play(sprite:GetDefaultAnimation())
    end
    local price = Cellphone.GetItemPrice(variant, subType);
    if (hidden) then
        sprite:Load("gfx/005.100_collectible.anm2", false);
        sprite:ReplaceSpritesheet(1, "gfx/items/collectibles/questionmark.png");
        sprite:LoadGraphics();
        sprite:Play("ShopIdle")
        price =15;
    end
    return {
        Variant = variant,
        SubType = subType,
        Sprite = sprite,
        Price = price
    }
end

function Cellphone.GenerateOffers()
    Cellphone.GeneratingOffers = true;
    local contents = Cellphone.GetAyazunContent(true);
    Cellphone.ClearAyazunContent();

    local room = THI.Game:GetRoom();
    local level = THI.Game:GetLevel()
    local roomType = room:GetType();
    local pool = RoomPools[roomType];
    if (not pool) then
        pool = RoomPools[RoomType.ROOM_DEFAULT];
    end

    local totalWeight = 0;
    for _, itemInfo in pairs(pool) do
        totalWeight = totalWeight + (itemInfo.Weight or 0);
    end

    local seeds = THI.Game:GetSeeds();
    local roomDesc = level:GetCurrentRoomDesc();
    local seedMulti = roomDesc.SafeGridIndex;
    local seed = seeds:GetStartSeed() + seeds:GetStageSeed (level:GetStage()) + seedMulti * 58115310;
    local rng = RNG();
    rng:SetSeed(seed, 0);

    local startIndex = 1;

    -- Always Appear Items.
    if (pool.Always) then
        for _, itemInfo in pairs(pool.Always) do
            local hidden = roomType == RoomType.ROOM_ARCADE and itemInfo.Variant == PickupVariant.PICKUP_COLLECTIBLE;
            local offer = Cellphone.GetOfferData(itemInfo, rng:Next(), hidden);
            table.insert(contents, offer);
            startIndex = startIndex + 1;
            if (startIndex > maxContentCount) then
                break;
            end
        end
    end

    for i = startIndex, maxContentCount do
        local weight = rng:RandomFloat() * totalWeight;
        for _, itemInfo in pairs(pool) do
            weight = weight - (itemInfo.Weight or 0);
            local hidden = roomType == RoomType.ROOM_ARCADE and itemInfo.Variant == PickupVariant.PICKUP_COLLECTIBLE;
            if (weight <= 0) then
                table.insert(contents, Cellphone.GetOfferData(itemInfo, rng:Next(), hidden));
                goto nextContent;
            end
        end
        ::nextContent::
    end
    
    Cellphone.GeneratingOffers = false;
end

function Cellphone.PurchaseItem(itemInfo)
    local globalData = Cellphone:GetAyazunData(true);
    local info = {
        Variant = itemInfo.Variant,
        SubType = itemInfo.SubType
    }
    if (itemInfo.Variant == PickupVariant.PICKUP_COLLECTIBLE) then
        itemPools:RemoveCollectible(itemInfo.SubType);
    elseif (itemInfo.Variant == PickupVariant.PICKUP_TRINKET) then
        itemPools:RemoveTrinket(itemInfo.SubType);
    end
    Cellphone.ClearAyazunContent();
    table.insert(globalData.Purchased, info);
end

function Cellphone.GetUpdatedPrice(player, origin)
    if (player:HasCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)) then
        local num = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE);
        return math.max(math.floor(origin / (2 ^ num)), 1);
    end
    return origin;
end

function Cellphone:UseCellphone(item, rng, player, flags, slot, varData)
    if (flags & UseFlag.USE_CARBATTERY <= 0) then
        if (item == Cellphone.Item) then
            local playerData = Cellphone.GetPlayerTempData(player, true);
            local contents = Cellphone.GetAyazunContent(true);
            local holding = HoldingActive:GetHoldingItem(player);
            if (holding <= 0 )then
                HoldingActive:Hold(item, player, slot);
                playerData.Selection = 0;
                if (#contents < maxContentCount) then
                    Cellphone.GenerateOffers();
                end
            elseif (holding == Cellphone.Item) then
                if (playerData.Selection == 0) then
                    HoldingActive:Cancel(player);
                else
                    -- Selecting an offering.
                    local itemInfo = contents[playerData.Selection];
                    local price = Cellphone.GetUpdatedPrice(player, itemInfo.Price);
                    if (player:GetNumCoins() >= price) then
                        HoldingActive:Cancel(player);
                        player:AnimateCollectible(CollectibleType.COLLECTIBLE_MOVING_BOX, "Pickup");
                        THI.SFXManager:Play(SoundEffect.SOUND_POWERUP3);

                        local purchaseStrings = PurchaseStrings;
                        local category = THI.StringCategories.DEFAULT;
                        local titleString = THI.GetText(category, purchaseStrings.Title);
                        local descString = THI.GetText(category, purchaseStrings.Desc);

                        THI.Game:GetHUD():ShowItemText (titleString, descString);
                        Cellphone.PurchaseItem(itemInfo);
                        player:AddCoins(-price)

                        if (player:HasCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES)) then
                            player:AddWisp(Cellphone.Item, player.Position);
                        end
                        return { Discharge = true };
                    else
                        THI.SFXManager:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ);
                    end
                end
            end
            return { Discharge = false };
        end
    end

end
Cellphone:AddCallback(ModCallbacks.MC_USE_ITEM, Cellphone.UseCellphone);

function Cellphone:PostPlayerEffect(player)
    if (IsPurchasing(player)) then
        local playerData = Cellphone.GetPlayerTempData(player, true);
        local contents = Cellphone.GetAyazunContent(false) or {};
        local offerCount = math.max(1, #contents);
        local controllerIndex = player.ControllerIndex;
        if (playerData.Selection > 0) then
            -- Choose Offers.
            if (Inputs.IsActionDown(ButtonAction.ACTION_SHOOTLEFT, controllerIndex)) then
                playerData.Selection = playerData.Selection - 1;
            end
            if (Inputs.IsActionDown(ButtonAction.ACTION_SHOOTRIGHT, controllerIndex)) then
                playerData.Selection = playerData.Selection + 1;
            end
            while (playerData.Selection <= 0 ) do
                playerData.Selection = playerData.Selection + offerCount;
            end
            while (playerData.Selection > offerCount ) do
                playerData.Selection = playerData.Selection - offerCount;
            end
        end

        -- Switch Close.
        if (playerData.Selection > 0) then
            if (Inputs.IsActionDown(ButtonAction.ACTION_SHOOTUP, controllerIndex)) then
                playerData.Selection = 0
            end
        else
            if (Inputs.IsActionDown(ButtonAction.ACTION_SHOOTDOWN, controllerIndex)) then
                playerData.Selection = 1;
            end
        end

        if (Input.IsActionPressed(ButtonAction.ACTION_DROP, controllerIndex)) then
            HoldingActive:Cancel(player);
        end
    end
end
Cellphone:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Cellphone.PostPlayerEffect);

function Cellphone.PostNewRoom()
    local contents = Cellphone.ClearAyazunContent();
end
Cellphone:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Cellphone.PostNewRoom);

function Cellphone:PostRender()
    local game = THI.Game;
    local contents = Cellphone.GetAyazunContent(false);
    for p, player in Detection.PlayerPairs() do
        local playerData = Cellphone.GetPlayerTempData(player, false);
        if (playerData and IsPurchasing(player)) then
            local pos = Screen.GetEntityRenderPosition(player, Vector(0, -80));
            WebsiteSprite:Render(pos);

            local selectionPos = pos + Vector(64, -64);
            if (contents) then
                local offerCount = #contents;
                for o = 1, offerCount do
                    local offer = contents[o];
                    local offerPos = pos + Vector((o - 1) * 32 - (offerCount - 1) * 16, -20); 
                    offer.Sprite:Render(offerPos);

                    local originPrice = offer.Price;
                    local price = Cellphone.GetUpdatedPrice(player, originPrice);
                    local color = KColor(1,1,1,1);
                    if (price < originPrice) then
                        color.Green = 0;
                        color.Blue = 0;
                    end
                    priceFont:DrawStringUTF8(tostring(price).."¢", offerPos.X - 16, offerPos.Y + 8, color, 32, true)
                end
                if (playerData.Selection > 0) then
                    selectionPos = pos + Vector((playerData.Selection - 1) * 32 - (offerCount - 1) * 16, -30); 
                end
            end
            -- Select Frame.
            SelectionSprite:Render(selectionPos);
        end
    end
end
Cellphone:AddCallback(ModCallbacks.MC_POST_RENDER, Cellphone.PostRender);

function Cellphone:PostNewStage()
    local globalData = Cellphone:GetAyazunData(false);
    if (globalData) then
        if (#globalData.Purchased > 0) then
            local game = THI.Game;
            local room = THI.Game:GetRoom();
            local index = room:GetGridSize() - room:GetGridWidth() * 2 + 1;
            if (game.Difficulty == Difficulty.DIFFICULTY_GREED or game.Difficulty == Difficulty.DIFFICULTY_GREEDIER) then
                index = 157;
            end
            local originPos = room:GetGridPosition(index);
            THI.SFXManager:Play(SoundEffect.SOUND_CASH_REGISTER);
            for i = #globalData.Purchased, 1, -1 do
                local info = globalData.Purchased[i];
                local pos = room:FindFreePickupSpawnPosition(originPos, 0, true);
                Isaac.Spawn(EntityType.ENTITY_PICKUP, info.Variant, info.SubType, pos, Vector.Zero, nil);
                table.remove( globalData.Purchased, i );
            end
        end
    end
end
Cellphone:AddCustomCallback(CLCallbacks.CLC_NEW_STAGE, Cellphone.PostNewStage);

function Cellphone:PostExit()
    Offers = {};
end
SaveAndLoad:AddCallback(Cellphone:GetMod(), SLCallbacks.SLC_POST_EXIT, Cellphone.PostExit);

return Cellphone;