state("Itorah", "1.0.0.0")
{
	// Defining pointers manually
	// Needs version check
	bool isLoading : "mono-2.0-bdwgc.dll", 0x004A7408, 0x210, 0xBBC;
	bool isDying : "mono-2.0-bdwgc.dll", 0x00495A90, 0xDF0, 0x18, 0x10, 0x28, 0x10, 0xAA8;
	bool getAbility : "UnityPlayer.dll", 0x0181D048, 0xC8, 0x70, 0x30, 0x8D0, 0x208;
	float witchHealth : "UnityPlayer.dll", 0x017DEB18, 0x0, 0x200, 0x28, 0xF4;
}

startup
{
	// Using asl-help to read scenes and pointers
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.AlertGameTime();
	vars.Helper.LoadSceneManager = true;

	// Define indices
	vars.id = new Dictionary<string, int>
	{
		{"name", 0}, 
		{"default", 1},
		{"tooltip", 2},
		{"category", 3},
		{"value", 4},
		{"willSplit", 5},

		{"enter", 0},
		{"ability", 1},
		{"boss", 2}
	};
	
	// Areas
	settings.Add("enter", true, "Area Entry");
	settings.SetToolTip("enter", "splits when entering an area for the first time");

	vars._entrySplits = new object[,]
	{
		{"enterAracan", true, "Aracan", "enter", "SpiderDungeon", false},
		{"enterNahuFields", true, "Nahu Fields", "enter", "WesternForrest", false},
		{"enterChimali", true, "Chimali", "enter", "Chimali", false},
		{"enterNahuFalls", true, "Nahu Falls", "enter", "EasternForrest", false},
		{"enterLostCity", true, "Lost City", "enter", "ForbiddenRuins1", false},
		{"enterRuins", true, "Forbidden Ruins", "enter", "ForbiddenRuins2", false},
		{"enterAbyss", true, "Green Abyss", "enter", "EarthTemple1", false},
		{"enterCradle", true, "Cradle", "enter", "EarthTemple2", false},
		{"enterDahlia", false, "Dahlia", "enter", "EarthTempleBoss", false},
		{"enterIcyCaverns", false, "Icy Caverns", "enter", "WaterTemple1", false},
		{"enterTlalocan", false, "Tlalocan", "enter", "WaterTemple2", false},
		{"enterStormChunks", true, "Storm Chunks", "enter", "StormTemple1", false},
		{"enterArchives", true, "Archives", "enter", "StormTemple2", false},
		{"enterQuetzalcoatl", false, "Quetzalcoatl", "enter", "StormTempleBoss", false},
		{"enterSmokyMountains", true, "Smoky Mountains", "enter", "FireTemple1", false},
		{"enterEmberBastion", true, "Ember Bastion", "enter", "FireTemple2", false},
		{"enterChantico", true, "Chantico", "enter", "FireTempleBoss", false},
		{"enterTempleGrounds", true, "Temple Grounds", "enter", "VioletGarden1", false},
		{"enterTemple", true, "Temple", "enter", "VioletGarden2", false},
		{"enterTemplePainting", true, "Temple Painting", "enter", "VioletGardenBoss", false}
	};

	// Ability pickup
	settings.Add("ability", true, "Abilities");
	settings.SetToolTip("ability", "splits on ability pickup");

	vars._abilitySplits = new object[,]
	{
		{"abilityHeal", true, "Heal", "ability", "SpiderDungeon", false},
		{"abilityChargeAttack", true, "Charge Attack", "ability", "EasternForrest", false},
		{"abilityWallJump", true, "Wall Jump", "ability", "ForbiddenRuins2", false},
		{"abilityDoubleJump", true, "Double Jump", "ability", "WesternForrest", false},
		{"abilityPogo", true, "Pogo", "ability", "EarthTemple2", false},
		{"abilityWeaponThrow", false, "Weapon Throw", "ability", "WaterTemple2", false},
		{"abilityAirDash", true, "Air Dash", "ability", "StormTemple2", false},
		{"abilityFlip", true, "Flip", "ability", "FireTemple2", false}
	};

	// Bosses
	settings.Add("boss", true, "Bosses");
	settings.SetToolTip("boss", "splits after completing a boss fight");

	vars._bossSplits = new object[,]
	{
		{"bossForbiddenRuins", false, "Ruins Escape", "boss", "ForbiddenRuins2", false},
		{"bossEarthTemple", false, "Dahlia", "boss", "EarthTempleBoss", false},
		{"bossWaterTemple", false, "Cleanse Tlalocan", "boss", "WaterTemple2", false},
		{"bossStormTemple", false, "Quetzalcoatl", "boss", "StormTempleBoss", false},
		{"bossFireTemple", true, "Chantico", "boss", "FireTempleBoss", false}
	};

	// Items
	settings.Add("item", true, "Items");
	settings.SetToolTip("item", "splits on item collection");

	vars._itemSplits = new object[,]
	{
		{"Pale Feather", false, "Pale Feather", "item"},
		{"Petrified Echo", false, "Petrified Echo", "item"},
		{"Orb Key", true, "Orb Key", "item"},
		{"Ruined Key", true, "Ruined Key", "item"},
		{"Sprout Key", false, "Sprout Key", "item"},
		{"Damp Key", false, "Damp Key", "item"},
		{"Electrified Key", true, "Electrified Key", "item"},
		{"Scalding Key", true, "Scalding Key", "item"},
		{"Violet Key", true, "Violet Key", "item"}
	};

	// Create settings from split objects
	vars.splits = new object[] {vars._entrySplits, vars._abilitySplits, vars._bossSplits, vars._itemSplits};
	foreach (object [,] splitsSet in vars.splits)
	{
		for (int i = 0; i <= splitsSet.GetUpperBound(0); i++)
		{
			settings.Add(
				(string)splitsSet[i, vars.id["name"]],
				(bool)splitsSet[i, vars.id["default"]],
				(string)splitsSet[i, vars.id["tooltip"]],
				(string)splitsSet[i, vars.id["category"]]
			);
		}
	}

	// End split
	settings.Add("end", true, "Ending");
	settings.SetToolTip("end", "splits when defeating Maiara");

	// Optional setting to split on each load
	settings.Add("load", false, "All Loads");
	settings.SetToolTip("load", "splits on all load screens, exclusive with Area Entries and Bosses");
	

	//Search for current scene and determine to split or not
	vars.CheckIfSplitFromScene = (Func<string, string, object[,], bool>)((value, rowKey, splitsSet) =>
	{
		// Find split index for current scene
		int currentSplit = -1;
		vars.Log("Trying " + splitsSet[0, vars.id["category"]] + " check.");
		for (int i = 0; i <= splitsSet.GetUpperBound(0); i++)
		{
			if ((string)splitsSet[i, vars.id[rowKey]] == value)
			{
				currentSplit = i;
				break;
			}
		}
		if (currentSplit == -1)
		{
			vars.Log("couldn't find value");
			return false;
		}
		// Check and disable willSplit at index
		if ((bool)splitsSet[currentSplit, vars.id["willSplit"]])
		{
			splitsSet[currentSplit, vars.id["willSplit"]] = false;
			vars.Log("Found " + splitsSet[0, vars.id["category"]] + ": " + splitsSet[currentSplit, vars.id["tooltip"]]);
			vars.Log("Disabling " + splitsSet[currentSplit, vars.id["tooltip"]] + " in list");
			return true;
		}
		vars.Log("Found disabled split " + splitsSet[currentSplit, vars.id["tooltip"]]);	
		return false;
	});

}

init
{
	// Find pointers for items and check amounts
	// Based on https://github.com/Jarlyk/Grime-AutoSplitter/blob/main/Grime.asl
	vars.UpdateBag = (Func<List<object[]>>)(() =>
	{
		var derefPtr = vars.Helper.Read<IntPtr>("mono-2.0-bdwgc.dll", 0x00495A90, 0xF20, 0x60, 0x70, 0x28, 0x10, 0x70, 0x18);
		if (derefPtr == IntPtr.Zero)
		{
			return null;
		}
		var count = vars.Helper.Read<int>(derefPtr + 24);
		var stackPtr = vars.Helper.Read<IntPtr>(derefPtr + 16);

		var itemPtrs = new List<IntPtr>();
		var items = new List<object[]>();

		// Find item pointers
		for (int i = 0; i < count; i++)
		{
			var itemPtr = vars.Helper.Read<IntPtr>(stackPtr + 32 + (8 * i));
			itemPtrs.Add(itemPtr);
		}

		// Make item object for each pointer
		foreach (IntPtr ptr in itemPtrs)
		{
			if (ptr != IntPtr.Zero)
			{
				// Follow offset chain to dev text
				var idPtr = vars.Helper.Read<IntPtr>(ptr + 16);
				var namePtr = vars.Helper.Read<IntPtr>(idPtr + 56);

				var name = vars.Helper.ReadString(namePtr + 32);
				var amount = vars.Helper.Read<int>(ptr + 32);

				object[] item = {name, amount};
				items.Add(item);
			}
		}
		return items;
	});

	// Compare bags for increase in splittable items
	vars.CheckItemIncrements = (Func<List<object[]>, List<object[]>, bool, bool>)((oldBag, currentBag, recentLoad) =>
	{
		// Check if the bag has been loaded for the last cycles
		if (oldBag == null || currentBag == null) return false;
		// Stop save loading issues
		if (oldBag.Count == 0 && (currentBag.Count != 1 || recentLoad)) return false;

		// Use bag size to determine required checks
		if (oldBag.Count > currentBag.Count) return false;
		if (oldBag.Count == currentBag.Count)
		{
			for (int i = 0; i < currentBag.Count; i++)
			{
				string itemName = (string) currentBag[i][0];
				if (itemName != "Shards" && settings[itemName])
				{
					// Compare at index when same size
					if ((int) currentBag[i][1] == (int) oldBag[i][1] + 1)
					{
						vars.Log(itemName + " has increased");
						return true;
					}
				}
			}
		}
		else if (oldBag.Count < currentBag.Count)
		{
			for (int i = 0; i < currentBag.Count; i++)
			{
				string itemName = (string) currentBag[i][0];
				if (itemName != "Shards" && settings[itemName])
				{
					// Find pair for item when sizes are different
					for (int k = 0; k < oldBag.Count; k++)
					{
						if (itemName == (string) oldBag[k][0])
						{
							if ((int) currentBag[i][1] == (int) oldBag[k][1] + 1)
							{
								vars.Log("New " + itemName);
								return true;
							}
							break;
						}
						// The item was found in current list but not old so it was just added
						vars.Log("First " + itemName);
						return true;
					}
				}
			}
		}
		return false;
	});

	// Set autosplits from settings
	vars.InitializeSplits = (Action)(() =>
	{
		var splits = new object[] {vars._entrySplits, vars._abilitySplits, vars._bossSplits};
		foreach (object [,] splitsSet in splits)
		{
			if (!settings[(string)splitsSet[0, vars.id["category"]]])
			{
				vars.Log("Skipping disabled category " + splitsSet[0, vars.id["category"]]);
				continue;
			}

			for (int i = 0; i <= splitsSet.GetUpperBound(0); i++)
			{
				splitsSet[i, vars.id["willSplit"]] = settings[(string)splitsSet[i, vars.id["name"]]];
			}
			vars.Log("Initialized " + splitsSet[0, vars.id["category"]] + " splits");
		}
		vars.entrySplits = splits[vars.id["enter"]];
		vars.abilitySplits = splits[vars.id["ability"]];
		vars.bossSplits = splits[vars.id["boss"]];
	});

	// Initialize values
	vars.entrySplits = vars._entrySplits;
	vars.abilitySplits = vars._abilitySplits;
	vars.bossSplits = vars._bossSplits;

	vars.oldBag = null;
	vars.currentBag = null;
	vars.trackWitch = false;
	vars.respawnLoad = false;
	current.activeScene = null;
	current.isLoading = true;
	
	vars.recentLoad = false;
	vars.cyclesSinceLoad = 0;
}

update
{
	// Update current scene
	current.activeScene = vars.Helper.Scenes.Active.Name ?? current.activeScene;
	if (old.activeScene != current.activeScene)
	{
		vars.Log(current.activeScene);
	}
	// Check if load was from death respawn
	if (!current.isLoading && old.isLoading) vars.respawnLoad = false;
	if (current.isDying) vars.respawnLoad = true;

	// Look for witch fight start
	if (current.activeScene == "VioletGardenBoss" && current.witchHealth == 90) vars.trackWitch = true;

	// Increase and check timer for edge case false autosplits
	if (vars.recentLoad && !current.isLoading)
	{
		vars.cyclesSinceLoad++;
		if (vars.cyclesSinceLoad >= 10)
		{
			vars.recentLoad = false;
			vars.Log("Restarting item splits");
		}
	}

	// Start the timer
	if (current.isLoading && !old.isLoading)
	{
		vars.Log("Stopping some item splits");
		vars.recentLoad = true;
		vars.cyclesSinceLoad = 0;
	}

	// Update bags
	if (settings["item"])
	{
		vars.oldBag = vars.currentBag;
		vars.currentBag = vars.UpdateBag();
	}
}

start
{
	return (old.activeScene == "TitleScreen" && current.activeScene == "Prologue");
}

onStart
{
	vars.InitializeSplits();
}

isLoading
{
	return current.isLoading;
}

split
{
	// Check for boss splits when entering loads
	if (current.isLoading && !old.isLoading && !vars.respawnLoad)
	{
		if (settings["load"]) return true;
		if (settings["boss"] && vars.CheckIfSplitFromScene(current.activeScene, "value", vars.bossSplits)) return true;
	}
	
	// Check for ability pickups
	if (current.getAbility && !old.getAbility && settings["ability"])
	{
		if (vars.CheckIfSplitFromScene(current.activeScene, "value", vars.abilitySplits)) return true;
	}
	
	// Check for enter splits when leaving loads
	if (current.activeScene != old.activeScene)
	{
		if (!settings["load"] && settings["enter"])
		{
			if (vars.CheckIfSplitFromScene(current.activeScene, "value", vars.entrySplits)) return true;
		}
	}

	// Watch final boss health after starting fight
	if (vars.trackWitch && current.witchHealth == 0)
	{
		vars.trackWitch = false;
		return settings["end"];
	}

	// Check for item increases
	if (settings["item"])
	{
		return vars.CheckItemIncrements(vars.oldBag, vars.currentBag, vars.recentLoad);
	}
	
	return false;
}
