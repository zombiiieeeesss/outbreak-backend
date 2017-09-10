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
| ------------ |-------- | ---------- | ------------- |
| status       | string  | Yes        | Must be one of `pending`, `active`, `complete` |
| round_length | integer | Yes        | Length of the round in days |
| title        | string  | No         | Optional name for the game |

**Example Request:**

```json
{
  "title": "zombieland",
  "round_length": 5
}
```

**Example Response:**

```json
{
  "title": "zombieland",
  "status": "pending",
  "round_length": 5,
  "player": {
    "status": "user-pending",
    "id": 1
  },
  "owner_id": 1,
  "id": 1
}
```
