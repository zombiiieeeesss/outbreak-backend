# Game

### List

`GET /v1/games`

**Headers:**
`Authorization: your-token`

**Example Response:**
```json
[
  {
    "title": "zombieland",
    "status": "qualifying",
    "round": 1,
    "round_length": 5,
    "player": {
      "status": "user-pending",
      "id": 1
    },
    "owner_id": 1,
    "id": 1
  }
]
```

### Create

`POST /v1/games`

**Headers:**

`Content-Type: application/json` <br />
`Authorization: your-token`

**Parameters:**

|**Name**|**Type**|**Required**|**Description**|
| ------------ |--------- | ---------- | ------------- |
| round_length | integer  | Yes        | Length of the round in days |
| start_time   | datetime | Yes        | The start time of the game |
| title        | string   | No         | Optional name for the game |

**Example Request:**

```json
{
  "title": "zombieland",
  "round_length": 5,
  "start_time": "2017-09-28 06:05:00.926573Z"
}
```

**Example Response:**

```json
{
  "title": "zombieland",
  "status": "pending",
  "round": 1,
  "round_length": 5,
  "player": {
    "status": "user-pending",
    "id": 1
  },
  "owner_id": 1,
  "id": 1
}
```
