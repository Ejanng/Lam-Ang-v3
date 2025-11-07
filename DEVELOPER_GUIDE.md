# Lam-Ang Chronicles - Developer Guide

## Overview
This guide provides technical information for developers who want to understand, modify, or extend the Lam-Ang Chronicles educational RPG game.

## Architecture

### Core Systems

#### 1. Game Manager (`scripts/game_manager.gd`)
The central singleton that manages:
- Game state and progression
- Player statistics (health, level, experience)
- Chapter unlocking and completion
- Quiz system and scoring
- Save/load functionality
- Inventory management

**Key Methods:**
- `load_game_data()`: Loads story content from JSON
- `get_chapter_data(chapter_id)`: Retrieves specific chapter information
- `submit_quiz_answer(chapter_id, answer_index)`: Processes quiz responses
- `complete_chapter(chapter_id)`: Marks chapter as completed and unlocks next
- `save_game()` / `load_game()`: Persistent storage

#### 2. Player Controller (`scripts/player.gd`)
Handles player character in exploration mode:
- Movement (WASD/Arrow keys)
- Interaction with objects/NPCs
- Health and stat management
- Animation states

#### 3. Dialogue System (`scripts/dialogue_system.gd`)
Manages NPC conversations:
- Sequential dialogue display
- Choice branches
- Consequences (items, experience)
- Speaker identification

#### 4. Combat System (`scripts/combat_system.gd`)
Turn-based combat mechanics:
- Player actions (Attack, Defend, Special, Flee)
- Enemy AI
- Damage calculation
- Victory/defeat handling
- Experience rewards

### Data Structure

#### Game Data (`data/game_data.json`)
JSON file containing:
- **story_chapters**: Array of chapter objects
  - id, title, description
  - content (narrative text)
  - educational_points (learning objectives)
  - quiz (question, options, correct answer, explanation)
- **characters**: Hero and NPC data with stats
- **enemies**: Opponent data for combat
- **items**: Collectible items and equipment

**Example Chapter Structure:**
```json
{
  "id": "chapter_1",
  "title": "The Birth of Lam-Ang",
  "description": "Learn about the miraculous birth...",
  "content": "Long narrative text...",
  "educational_points": [
    "Point 1",
    "Point 2"
  ],
  "quiz": {
    "question": "What made Lam-Ang special?",
    "options": ["A", "B", "C", "D"],
    "correct": 0,
    "explanation": "Explanation text"
  }
}
```

### Scene Structure

#### UI Scenes
- `main_menu.tscn`: Entry point, navigation hub
- `story_intro.tscn`: Game introduction
- `chapter_select.tscn`: Chapter navigation with progress
- `chapter_scene.tscn`: Story content display
- `quiz_scene.tscn`: Educational assessment

#### Gameplay Scenes
- `game_world.tscn`: Exploration map with player
- `player.tscn`: Player character instance
- `dialogue_system.tscn`: NPC conversation UI
- `combat_system.tscn`: Battle interface

#### About/Info
- `about.tscn`: Information about the epic

## Adding New Content

### Adding a New Chapter

1. **Edit `data/game_data.json`:**
```json
{
  "id": "chapter_6",
  "title": "New Chapter Title",
  "description": "Brief description",
  "content": "Full story text...",
  "educational_points": [
    "Learning point 1",
    "Learning point 2"
  ],
  "quiz": {
    "question": "Quiz question?",
    "options": ["A", "B", "C", "D"],
    "correct": 1,
    "explanation": "Why B is correct"
  }
}
```

2. **Chapter automatically appears** in chapter_select scene
3. **Unlocking logic** is handled by game_manager

### Adding a New Character/NPC

1. **Add to `data/game_data.json` characters array:**
```json
{
  "id": "new_character",
  "name": "Character Name",
  "description": "Character background",
  "stats": {
    "strength": 7,
    "intelligence": 8,
    "wisdom": 6,
    "charisma": 9
  }
}
```

2. **Create NPC instance in game_world:**
   - Add CharacterBody2D node
   - Attach `scripts/npc.gd`
   - Set dialogue in inspector

### Adding New Items

Edit `data/game_data.json` items array:
```json
{
  "id": "new_item",
  "name": "Item Name",
  "description": "What it does",
  "type": "weapon|consumable|companion",
  "stats": {
    "attack": 20
  }
}
```

### Adding Enemies

Add to enemies array in game_data.json with stats and health values.

## Extending Systems

### Custom Quiz Types

In `scripts/quiz_scene.gd`, modify `display_quiz()` to handle:
- Multiple choice (current)
- True/false
- Fill in the blank
- Matching
- Image-based questions

### Advanced Combat

Extend `scripts/combat_system.gd` with:
- Skills and abilities
- Status effects (poison, stun)
- Multiple enemies
- Party system
- Equipment effects

### Dialogue Branches

Use choice system in dialogue_system.gd:
```gdscript
{
  "lines": [
    {
      "speaker": "NPC",
      "text": "Choose your path:",
      "choices": [
        {
          "text": "Option A",
          "consequence": {"add_item": "sword"},
          "next_line": 1
        },
        {
          "text": "Option B",
          "consequence": {"experience": 50},
          "next_line": 2
        }
      ]
    }
  ]
}
```

### Save System Enhancement

Current save system in game_manager.gd saves to `user://savegame.dat`. 

To add cloud saves:
1. Integrate with backend API
2. Add authentication
3. Sync local + cloud data

## Testing

### Manual Testing Checklist
- [ ] All chapters load correctly
- [ ] Quizzes function and score properly
- [ ] Save/load preserves state
- [ ] UI navigation works
- [ ] Player movement responsive
- [ ] Combat system balanced
- [ ] Dialogue displays correctly

### Adding Automated Tests

Create test scenes in `tests/` directory:
```gdscript
extends GutTest

func test_chapter_completion():
    var gm = GameManager
    gm.complete_chapter("chapter_1")
    assert_true("chapter_1" in gm.player_progress["chapters_completed"])
```

## Performance Optimization

### Current Optimizations
- Minimal draw calls in UI
- Efficient collision detection
- JSON parsing done once at startup

### Future Optimizations
- Asset streaming for large worlds
- LOD for distant objects
- Texture atlases
- Audio compression

## Debugging

### Common Issues

**Issue: GameManager not found**
- Ensure autoload is set in project.godot
- Check `GameManager` singleton is initialized

**Issue: Scene not loading**
- Verify scene path is correct
- Check for syntax errors in scripts

**Issue: Quiz not working**
- Validate JSON structure
- Check array indexing

### Debug Tools

Enable debug overlay in game_manager.gd:
```gdscript
func _process(_delta):
    if OS.is_debug_build():
        print_debug_info()
```

## Localization

To add language support:

1. **Create translation files** in `res://locales/`
2. **Update project.godot** with locale settings
3. **Use tr() function** for all display text:
```gdscript
label.text = tr("CHAPTER_TITLE")
```

## Publishing

### Export Settings

For each platform:
1. **Windows**: Enable console for debugging
2. **Linux**: Set executable permissions
3. **Web**: Enable SharedArrayBuffer
4. **Android/iOS**: Configure permissions

### Asset Preparation
- Compress images (PNG-8 for UI)
- Convert audio to OGG
- Minimize JSON files
- Remove unused resources

## Contributing

### Code Style
- Use tabs for indentation
- `snake_case` for variables/functions
- `PascalCase` for classes
- Comment complex logic
- Keep functions under 50 lines

### Pull Request Process
1. Fork repository
2. Create feature branch
3. Test thoroughly
4. Update documentation
5. Submit PR with description

## Resources

### Godot Documentation
- https://docs.godotengine.org/

### GDScript Reference
- https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/

### About the Epic
- Research "Biag ni Lam-Ang" for authentic content
- Consult Filipino literature scholars
- Respect cultural significance

## Support

For technical questions or contributions:
- GitHub Issues
- Project Wiki
- Community Discord (if available)

---

**Remember:** This is an educational tool. Ensure all content is accurate, respectful, and age-appropriate.
