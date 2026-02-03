# Calibration Files

This directory stores calibration files for robots and teleoperators.

## Structure

- `robots/` - Calibration files for individual robots
- `teleoperators/` - Calibration files for teleoperators

## Using Local Calibration Files

To use calibration files stored in this repository instead of the default cache directory, set the environment variable:

```bash
export HF_LEROBOT_CALIBRATION=/path/to/lerobot/calibration
```

Or in Python:

```python
import os
from pathlib import Path

os.environ["HF_LEROBOT_CALIBRATION"] = str(Path(__file__).parent / "calibration")
```

## File Format

Calibration files are stored as JSON files named after the robot/teleoperator IDs:

```
robots/
  robot_name.json
  another_robot.json

teleoperators/
  teleoperator_name.json
```

Each JSON file contains the calibration parameters specific to that robot or teleoperator.
