# Lam-Ang Chronicles

An educational RPG game based on **"Biag ni Lam-Ang"**, a famous Ilocano epic poem from the Philippines.

## About the Game

Lam-Ang Chronicles is an interactive educational experience that brings to life one of the most important works of Philippine literature. Through gameplay, players learn about pre-colonial Filipino culture, Ilocano traditions, and the legendary tale of Lam-Ang.

## About Biag ni Lam-Ang

"Biag ni Lam-Ang" (The Life of Lam-Ang) is an epic poem from the Ilocano people of northern Philippines. It tells the story of Lam-Ang, a hero born with supernatural abilities who:
- Could speak before birth and chose his own name
- Avenged his father's death
- Courted and married the beautiful Ines Kannoyan
- Was resurrected by his loyal animal companions after being killed

The epic reflects pre-colonial Filipino values including:
- Family honor and filial piety
- Courage and bravery
- Perseverance and determination
- Traditional courtship practices
- Indigenous spirituality

## Game Features

### Educational Content
- **5 Story Chapters**: Experience the full epic poem divided into manageable educational segments
- **Interactive Quizzes**: Test your knowledge after each chapter
- **Educational Points**: Learn key cultural and historical information
- **Progress Tracking**: Monitor your learning journey

### RPG Elements
- **Character Development**: Level up as you progress through the story
- **Stats System**: Strength, Intelligence, Wisdom, and Charisma
- **Inventory System**: Collect legendary items from the story
- **Quest System**: Complete chapters and challenges

### Game Mechanics
- Story-driven gameplay
- Educational assessments
- Progress saving and loading
- Multiple chapters to unlock

## Technical Details

- **Engine**: Godot 4.2+
- **Language**: GDScript
- **Resolution**: 1280x720 (scalable)
- **Platform**: Cross-platform (Windows, Linux, macOS, Web)

## Project Structure

```
Lam-Ang-v3/
├── project.godot          # Main Godot project file
├── icon.svg               # Game icon
├── scenes/                # Game scenes
│   ├── main_menu.tscn    # Main menu screen
│   ├── story_intro.tscn  # Introduction scene
│   ├── chapter_select.tscn # Chapter selection
│   ├── chapter_scene.tscn  # Chapter display
│   ├── quiz_scene.tscn   # Quiz interface
│   ├── about.tscn        # About the epic
│   └── player.tscn       # Player character
├── scripts/               # GDScript files
│   ├── game_manager.gd   # Core game logic
│   ├── main_menu.gd      # Main menu controller
│   ├── chapter_select.gd # Chapter selection logic
│   ├── chapter_scene.gd  # Chapter display logic
│   ├── quiz_scene.gd     # Quiz system
│   └── player.gd         # Player controller
├── data/                  # Game data
│   └── game_data.json    # Story, characters, items
└── assets/                # Game assets
    ├── sprites/           # Character and environment sprites
    ├── sounds/            # Audio files
    └── fonts/             # Custom fonts

```

## Installation & Running

1. **Install Godot 4.2 or higher**
   - Download from https://godotengine.org/

2. **Clone the repository**
   ```bash
   git clone https://github.com/Ejanng/Lam-Ang-v3.git
   cd Lam-Ang-v3
   ```

3. **Open in Godot**
   - Launch Godot Engine
   - Click "Import"
   - Navigate to the project folder
   - Select `project.godot`
   - Click "Import & Edit"

4. **Run the game**
   - Press F5 or click the "Play" button in Godot

## How to Play

1. **Start a New Game**: Begin your journey through the epic
2. **Read Each Chapter**: Learn about Lam-Ang's adventures
3. **Complete Quizzes**: Test your understanding of the story
4. **Progress Through Chapters**: Unlock new content as you learn
5. **Track Your Progress**: View your scores and completed chapters

### Controls
- **Arrow Keys / WASD**: Movement (when in exploration mode)
- **E / Space**: Interact
- **ESC**: Menu
- **Mouse**: Navigate UI elements

## Educational Goals

This game aims to:
- Make Philippine literature accessible and engaging
- Teach about Ilocano culture and pre-colonial Filipino society
- Preserve and promote indigenous storytelling traditions
- Combine entertainment with education
- Inspire interest in Philippine cultural heritage

## Game Content

### Chapters
1. **The Birth of Lam-Ang**: Learn about his miraculous birth
2. **The Quest for Don Juan**: Follow Lam-Ang's journey to avenge his father
3. **The Courtship of Ines Kannoyan**: Witness his pursuit of true love
4. **The Great Trial**: Experience his greatest challenges
5. **Death and Resurrection**: Learn about his ultimate trial

### Characters
- **Lam-Ang**: The legendary hero with supernatural powers
- **Ines Kannoyan**: Beautiful and virtuous, Lam-Ang's wife
- **Namongan**: Lam-Ang's supportive mother
- **Don Juan**: Lam-Ang's brave father
- **Magic Rooster & Loyal Dog**: Lam-Ang's faithful companions

## Development

### Adding New Content

To add new chapters, edit `data/game_data.json`:
```json
{
  "story_chapters": [
    {
      "id": "chapter_6",
      "title": "New Chapter",
      "description": "Chapter description",
      "content": "Story content...",
      "educational_points": ["Point 1", "Point 2"],
      "quiz": {
        "question": "Question text",
        "options": ["A", "B", "C", "D"],
        "correct": 0,
        "explanation": "Explanation text"
      }
    }
  ]
}
```

### Extending Functionality

The game is designed to be extensible:
- Add new game mechanics in `scripts/game_manager.gd`
- Create new scenes in the `scenes/` directory
- Add assets in the `assets/` directory
- Implement new features following the existing code structure

## Contributing

Contributions are welcome! Areas for improvement:
- Additional story chapters or side quests
- Enhanced graphics and animations
- Sound effects and music
- Translations to other languages
- Additional quiz types and learning activities
- Multiplayer or competitive modes

## License

This project is open source under the MIT License. See the LICENSE file for details.

The story of "Biag ni Lam-Ang" is a cultural heritage of the Ilocano people and is in the public domain.

## Credits

- **Game Development**: Created with Godot Engine
- **Original Epic**: "Biag ni Lam-Ang" - Traditional Ilocano epic poem
- **Educational Design**: Focused on Philippine cultural heritage

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Contact the development team

---

*Preserving Philippine cultural heritage through interactive education*