state("Itorah", "1.0.0.0")
{
	// Defining pointers manually
	// Needs version check
	bool isLoading : "mono-2.0-bdwgc.dll", 0x004A7408, 0x210, 0xBBC;
	bool isDying : "mono-2.0-bdwgc.dll", 0x00495A90, 0xDF0, 0x18, 0x10, 0x28, 0x10, 0xAA8;
	bool getAbility : "UnityPlayer.dll", 0x0181D048, 0xC8, 0x70, 0x30, 0x8D0, 0x208;
	float witchHealth : "UnityPlayer.dll", 0x017DEB18, 0x0, 0x70, 0x28, 0x64;
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
		{"exit", 1},
		{"ability", 2},
		{"bossStart", 3},
		{"echoesPhase", 4},
		{"boss", 5},
		{"event", 6}
	};
	
	// Start defining splits by category
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
		{"enterDahlia", false, "Dahlia Room", "enter", "EarthTempleBoss", false},
		{"enterIcyCaverns", false, "Icy Caverns", "enter", "WaterTemple1", false},
		{"enterTlalocan", false, "Tlalocan", "enter", "WaterTemple2", false},
		{"enterStormChunks", true, "Storm Chunks", "enter", "StormTemple1", false},
		{"enterArchives", true, "Archives", "enter", "StormTemple2", false},
		{"enterQuetzalcoatl", false, "Quetzalcoatl Room", "enter", "StormTempleBoss", false},
		{"enterSmokyMountains", true, "Smoky Mountains", "enter", "FireTemple1", false},
		{"enterEmberBastion", true, "Ember Bastion", "enter", "FireTemple2", false},
		{"enterChantico", false, "Chantico Room", "enter", "FireTempleBoss", false},
		{"enterTempleGrounds", true, "Temple Grounds", "enter", "VioletGarden1", false},
		{"enterTemple", true, "Temple", "enter", "VioletGarden2", false},
		{"enterTemplePainting", true, "Temple Painting", "enter", "VioletGardenBoss", false}
	};

	// Exits
	settings.Add("exit", true, "Area Exits");
	settings.SetToolTip("exit", "splits when exiting an area from a specific transition for the first time");
	vars._exitSplits = new object[,]
	{
		
		{"exitRuins", true, "Forbidden Ruins Exit", "exit", "ForbiddenRuins1_2cfd0392-6093-4008-b6cb-51de4abed22b", false},
		{"exitUpperLostCity", true, "Lost City Upper Exit", "exit", "EasternForrest_60a4da61-0498-4f4a-94b8-b7fce887ac72", false},
		{"exitCradle", true, "Cradle Exit", "exit", "EarthTemple1_eed23c79-bcfe-4a37-b7b5-7ed7e2ad6b85", false},
		{"exitLeftAbyss", true, "Green Abyss Left Exit", "exit", "WesternForrest_584c55dc-463e-407c-b102-ae322ed0dcb2", false},
		//{"exitLeftIcyCaverns", false, "Icy Caverns Left Exit", "exit", "WaterTemple1", false},
		{"exitArchives", true, "Archives", "exit", "StormTemple1_6a8e49ad-eeb9-4b16-9296-552611850e41", false},
		{"exitStormChunks", true, "Storm Chunks Lower Exit", "exit", "WesternForrest_2ad8a48b-d415-4f9a-9567-b8d7b1641add", false}
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

	// Boss first encountered
	settings.Add("bossStart", true, "Boss Fight Starts");
	settings.SetToolTip("bossStart", "splits at first start of a boss fight");
	vars._bossStartSplits = new object[,]
	{
		{"bossStartVioletKnight", false, "Violet Knight", "bossStart", "7f3d008f-8f7b-475a-9ce3-3eccea39b560", false},
		{"bossStartSpiderQueen", false, "Spider Queen", "bossStart", "98a47177-914e-41fc-8f48-8486785de15d", false},
		{"bossStartRuinsChase", false, "Ruins Chase Starts", "bossStart", "9bbae203-1bd2-40d9-b252-91ab89081e3f", false},
		{"bossStartDhalia", false, "Dhalia", "bossStart", "d24e945f-3e42-4c88-9f78-b8ee966391ba", false},
		{"bossStartTlalocanFirst", false, "First Tlalocan Boss", "bossStart", "088a6dc9-bde2-4658-85a7-83f43f9dbfa3", false},
		{"bossStartQuetz", false, "Quetzalcoatl", "bossStart", "ec99c8da-69a1-4cd4-9886-1c793899ea61", false},
		{"bossStartChantico", true, "Chantico", "bossStart", "422fa91c-ab58-433b-a8cb-e9b9b2be8411", false}
	};
	// Using seperate array for different check
	vars._echoesPhaseSplits = new object[,]
	{
		{"bossStartEchoesP1", true, "Elemental Echoes", "bossStart", 1, false},
		{"bossStartEchoesP2", false, "Elemental Echoes Phase 2", "bossStart", 2, false},
		{"bossStartEchoesP3", false, "Elemental Echoes Phase 3", "bossStart", 3, false}
	};

	// Bosses killed
	settings.Add("boss", true, "Boss Defeated");
	settings.SetToolTip("boss", "splits after defeating a boss");
	vars._bossSplits = new object[,]
	{
		{"bossVioletKnight", false, "Violet Knight", "boss", "56f51022-aa1e-476b-99d4-a9b94cb88925", false},
		{"bossSpiderQueen", false, "Spider Queen", "boss", "c64d8f63-8a19-40be-8386-f3b4c35fbd91", false},
		{"bossRuinsEscape", false, "Ruins Escape", "boss", "48339759-74ba-4e5e-a86d-2433b6e22de0", false},
		{"bossDhalia", false, "Dhalia", "boss", "6ad6ad4f-c744-4d90-8b4d-b9cbbb8db842", false},
		{"bossTlalocanSecond", false, "Second Tlalocan Boss", "boss", "19b81504-05f0-4e0c-af96-5fcce2eb5346", false},
		{"bossTlalocanFinal", false, "Cleanse Tlalocan", "boss", "b86ef633-ab2d-45e1-9848-f9b285414a1f", false},
		{"bossQuetz", false, "Quetzalcoatl", "boss", "10f1de22-ab31-4e54-895c-72758407211b", false},
		{"bossChantico", true, "Chantico", "boss", "1ca3d72f-7b6b-4d00-ba1b-575c9268987b", false},
		{"bossEchoes", true, "Elemental Echoes", "boss", "9ef40de3-4fcf-49e8-8ca1-6f4c065cd218", false}
	};

	// Story events
	settings.Add("event", true, "Story Events");
	settings.SetToolTip("event", "splits when reaching this story event");
	vars._eventSplits = new object[,]
	{
		{"eventSpiderChase", false, "Spider Chase Sequence Starts", "event", "fc88bdff-7f7c-4285-b0fd-61c039d6cb20", false},
		{"eventRuinsFall", false, "Ruins Floor Collapses", "event", "88a2a429-414a-44a9-8505-ede364af9f57", false},
		{"eventRuinsElevator", false, "Ruins Elevator Sequence Starts", "event", "e2bfac82-9533-4ab7-a4fb-2ec3bcf3f9f2", false},
		{"eventTlalocanAhui", false, "Tlalocan Ahui Meeting After First Boss", "event", "85a9b1e7-eb3a-49bc-98e1-f835d0871df3", false},
		{"eventChanticoMeeting", true, "Ember Bastion Chantico Meeting", "event", "166503f5-cf65-4907-83a9-87ea63049315", false}
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
	vars.splits = new object[] {vars._entrySplits, vars._exitSplits, vars._abilitySplits, vars._bossStartSplits, vars._echoesPhaseSplits, vars._bossSplits, vars._eventSplits, vars._itemSplits};
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
	settings.SetToolTip("load", "splits on all load screens, exclusive with Area Entries and Area Exits");
	
	// Search for value and determine to split or not
	vars.CheckStringSplit = (Func<string, object[,], bool>)((value, splitsSet) =>
	{
		// Find split index for value
		int currentSplit = -1;
		vars.Log("Trying " + splitsSet[0, vars.id["category"]] + " check.");
		for (int i = 0; i <= splitsSet.GetUpperBound(0); i++)
		{
			if ((string)splitsSet[i, vars.id["value"]] == value)
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

	// Search list for value and return list with the value removed if it was present
	vars.CheckStorySplit = (Func<string, List<string>, List<string>>)((value, splitsSet) =>
	{
		for (int i = 0; i < splitsSet.Count; i++)
		{
			if (splitsSet[i] == value)
			{
				splitsSet.RemoveAt(i);
				vars.Log("Found story change");
				break;
			}
		}
		return splitsSet;
	});

	// Check possible offsets for correct pointer
	vars.CheckIsdOffsets = (Func<int>)(() =>
	{
		foreach (int offset in new int[] {0xF10, 0xF48})
		{
			if (vars.Helper.Read<int>("mono-2.0-bdwgc.dll", 0x00495A90, offset, 0x20, 0x10, 0x28, 0x10, 0x68, 0x30) == 5)
			{
				vars.Log("Found session data offset: " + offset);
				return offset;
			}
		}
		return 0;
	});
	vars.CheckStoryOffsets = (Func<int>)(() =>
	{
		foreach (int offset in new int[] {0xF30, 0xF68})
		{
			var attemptGuid = vars.Helper.ReadString("mono-2.0-bdwgc.dll", 0x00495A90, offset, 0x70, 0x30, 0x10, 0x28, 0x18);
			//vars.Log(attemptGuid);
			if (attemptGuid != null  && attemptGuid.Length >= 36)
			{
				vars.Log("Found story offset: " + offset);
				return offset;
			}
		}
		return 0;
	});

	// Find pointers for items and check amounts
	// Based on https://github.com/Jarlyk/Grime-AutoSplitter/blob/main/Grime.asl
	vars.UpdateBag = (Func<IntPtr, List<object[]>>)((isdPtr) =>
	{
		var itemBagPtr = vars.Helper.Read<IntPtr>(isdPtr + 112);
		var listPtr = vars.Helper.Read<IntPtr>(itemBagPtr + 24);
		if (listPtr == IntPtr.Zero)
		{
			return null;
		}
		var count = vars.Helper.Read<int>(listPtr + 24);
		var stackPtr = vars.Helper.Read<IntPtr>(listPtr + 16);

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

	// Search pointers list for guid matching story criteria
	vars.FindStoryGuid = (Func<int, string, string>)((offset, oldGuid) =>
	{
		if (offset == 0) return null;
		for (int i = 0; i < 8; i++)
		{
			var guidPtr = vars.Helper.Read<IntPtr>("mono-2.0-bdwgc.dll", 0x00495A90, offset, 0x70, 48 + (i * 8), 0x10, 0x28);
			var guid = vars.Helper.ReadString(guidPtr + 0x18);
			if (guid == null) break;
			if (guid.Length == 36) return guid;
		}
		return oldGuid;
	});
}

init
{
	// Load the ONLY useful class with a static instance in the entire game
	vars.Helper.TryLoad = (Func<dynamic, bool>)(loader =>
	{
		vars.witchHelper = loader["Assembly-CSharp", "GrimbartTales.Platformer2D.SpecialEnemies.WitchBossBattleHelper"];
		vars.loader = loader;
		return true;
	});

	// Split from echoes fight phase
	vars.CheckEchoesPhase = (Func<IntPtr, object[,], bool>)((ptr, splitsSet) =>
	{
		if (vars.Helper.Read<int>(ptr + 0x88) != 3) return false; 
		var currentPhase = vars.Helper.Read<int>(ptr + 0x8c);
		for (int i = 0; i <= splitsSet.GetUpperBound(0); i++)
		{
			if ((int)splitsSet[i, vars.id["value"]] == currentPhase)
			{
				if ((bool)splitsSet[i, vars.id["willSplit"]])
				{
					splitsSet[i, vars.id["willSplit"]] = false;
					vars.Log("Entered echoes phase " + currentPhase);
					return true;
				}
				break;
			}
		}
		return false;
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
		var splits = new object[] {vars._entrySplits, vars._exitSplits, vars._abilitySplits, vars._bossStartSplits, vars._echoesPhaseSplits, vars._bossSplits, vars._eventSplits};
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
		vars.exitSplits = splits[vars.id["exit"]];
		vars.abilitySplits = splits[vars.id["ability"]];
		vars.bossStartSplits = splits[vars.id["bossStart"]];
		vars.bossSplits = splits[vars.id["boss"]];
		vars.eventSplits = splits[vars.id["event"]];
	});

	// Combine each story category for easier comparison
	vars.CombineStorySplits = (Func<object[], List<string>>)((storySplits) =>
	{
		List<string> combinedSplits = new List<string>(0);
		foreach (object [,] splitsSet in storySplits)
		{
			if (!settings[(string)splitsSet[0, vars.id["category"]]]) continue;
			for (int i = 0; i <= splitsSet.GetUpperBound(0); i++)
			{
				if ((bool)splitsSet[i, vars.id["willSplit"]]) combinedSplits.Add((string)splitsSet[i, vars.id["value"]]);
			}
		}
		return combinedSplits;
	});

	// Initialize values
	vars.entrySplits = vars._entrySplits;
	vars.exitSplits = vars._exitSplits;
	vars.abilitySplits = vars._abilitySplits;
	vars.bossStartSplits = vars._bossStartSplits;
	vars.echoesPhaseSplits = vars._echoesPhaseSplits;
	vars.bossSplits = vars._bossSplits;
	vars.eventSplits = vars._eventSplits;
	vars.combinedStorySplits = new List<string>();

	vars.checkStory = false;
	vars.storyOffset = 0;
	vars.isdOffset = 0;
	vars.oldBag = null;
	vars.currentBag = null;
	vars.oldGuid = null;
	vars.currentGuid = null;
	vars.oldCheckpoint = null;
	vars.currentCheckpoint = null;
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

	// Look for witch fights
	if (current.activeScene == "VioletGardenBoss" && current.witchHealth == 90) vars.trackWitch = true;

	// Increase and check load timer for edge case false autosplits
	if (vars.recentLoad && !current.isLoading)
	{
		vars.cyclesSinceLoad++;
		if (vars.cyclesSinceLoad >= 10)
		{
			vars.recentLoad = false;
		}
	}
	// Start the timer since load
	if (current.isLoading && !old.isLoading)
	{
		vars.recentLoad = true;
		vars.cyclesSinceLoad = 0;
	}

	// Look for correct isd and story pointers
	if (vars.isdOffset == 0) vars.isdOffset = vars.CheckIsdOffsets();
	if (vars.isdOffset != 0  && vars.storyOffset == 0) vars.storyOffset = vars.CheckStoryOffsets();
	// Find dereferenced session data pointer
	vars.isdPtr = vars.Helper.Read<IntPtr>("mono-2.0-bdwgc.dll", 0x00495A90, vars.isdOffset, 0x20, 0x10, 0x28, 0x10);

	// Update bags
	if (settings["item"])
	{
		vars.oldBag = vars.currentBag;
		vars.currentBag = vars.UpdateBag(vars.isdPtr);
	}
	// Find story
	if (vars.checkStory)
	{
		vars.oldGuid = vars.currentGuid;
		vars.currentGuid = vars.FindStoryGuid(vars.storyOffset, vars.oldGuid);
	}
	// Find newest load
	if (settings["exit"])
	{
		var loadingPtr = vars.Helper.Read<IntPtr>(vars.isdPtr + 0x28);
		vars.currentCheckpoint = vars.Helper.ReadString(loadingPtr + 0x40);
	}
}

start
{
	return (old.activeScene == "TitleScreen" && current.activeScene == "Prologue");
}

onStart
{
	vars.InitializeSplits();
	vars.combinedStorySplits = vars.CombineStorySplits(new object[] {vars.bossStartSplits, vars.bossSplits, vars.eventSplits});
	if (vars.combinedStorySplits.Count > 0) vars.checkStory = true;
}

isLoading
{
	return current.isLoading;
}

split
{
	// Check for loads
	if (current.isLoading && !old.isLoading && !vars.respawnLoad)
	{
		if (settings["load"]) return true;
	}
	
	// Check for ability pickups
	if (current.getAbility && !old.getAbility && settings["ability"])
	{
		if (vars.CheckStringSplit(current.activeScene, vars.abilitySplits)) return true;
	}
	
	// Check for enter splits when leaving loads
	if (current.activeScene != old.activeScene)
	{
		if (!settings["load"] && settings["enter"])
		{
			if (vars.CheckStringSplit(current.activeScene, vars.entrySplits)) return true;
		}
	}

	// Check for story progress
	if (vars.checkStory)
	{
		if (vars.oldGuid != vars.currentGuid)
		{
			int oldSize = vars.combinedStorySplits.Count;
			vars.combinedStorySplits = vars.CheckStorySplit(vars.currentGuid, vars.combinedStorySplits);
			if (vars.combinedStorySplits.Count < oldSize) return true;
		}
	}

	// Check the most recently loaded checkpoint to find load
	if (!settings["load"] && settings["exit"])
	{
		if (vars.currentCheckpoint != vars.oldCheckpoint && vars.currentCheckpoint != null && vars.oldCheckpoint != null)
		{
			vars.oldCheckpoint = vars.currentCheckpoint;
			if (vars.CheckStringSplit(vars.currentCheckpoint, vars.exitSplits)) return true;
		}
		else
		{
			vars.oldCheckpoint = vars.currentCheckpoint;
		}
	}

	// Reload WitchBossBattleHelper Class if static address was not found earlier
	// Get dereferenced instance pointer and use to check current boss phase
	if (current.activeScene == "VioletGardenBoss" && settings["bossStart"])
	{
		if (vars.witchHelper.Static == IntPtr.Zero) vars.witchHelper = vars.loader["Assembly-CSharp", "GrimbartTales.Platformer2D.SpecialEnemies.WitchBossBattleHelper"];
		vars.echoesPtr = vars.Helper.Read<IntPtr>(vars.witchHelper.Static + vars.witchHelper["_instance"]);
		if (vars.CheckEchoesPhase(vars.echoesPtr, vars.echoesPhaseSplits)) return true;
	}

	// Watch final boss health after starting fight
	if (vars.trackWitch && current.witchHealth == 0)
	{
		vars.trackWitch = false;
		if (settings["end"]) return true;
	}

	// Check for item increases
	if (settings["item"])
	{
		if (vars.CheckItemIncrements(vars.oldBag, vars.currentBag, vars.recentLoad)) return true;
	}
	
	return false;
}