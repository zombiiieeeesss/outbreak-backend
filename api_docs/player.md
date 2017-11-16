# Player

### Create

`POST /v1/players`

**Headers:**

`Content-Type: application/json` <br />
`Authorization: your-token`

**Parameters:**

|**Name**|**Type**|**Required**|**Description**|
| ------------ |-------- | ---------- | ------------- |
| game_id | integer  | Yes | ID of the game for which a player is being added |
| user_id | integer | Yes  | ID of the user being added to the game|

**Example Request:**

```json
{
  "user_ids": [727, 728],
  "game_id": 93
}
```

**Example Response:**

```json
[
  {
    "game_id": 93,
    "id": 115,
    "status": "user-pending",
    "user": {
      "email": "email-2@example.com",
       "id": 727,
       "username": "email-2@example.com"
    }
  },
  {
    "game_id": 93,
    "id": 116,
    "status": "user-pending",
    "stats": null,
    "user": {
      "email": "email-3@example.com",
      "id": 728,
      "username": "email-3@example.com"
    }
  }
]
```

### Update

`PATCH /v1/players/:id`

**Headers:**

`Content-Type: application/json` <br />
`Authorization: your-token`

**Parameters:**

|**Name**|**Type**|**Required**|**Description**|
| ------------ |-------- | ---------- | ------------- |
| player_id | integer  | Yes | ID of the player being updated |
| player | map | Yes  | Object containing attrs to be updated on existing player |

**Example Request:**

```json
{
  "player": {
    "stats": {
      "is_human": true,
      "distance": 100,
    }
  }
}
```

**Example Response:**

```json
  {
    "game_id": 93,
    "id": 115,
    "status": "user-pending",
    "stats": {
      "is_human": true,
      "distance": 100
    },
    "user": {
      "email": "email-2@example.com",
      "id": 727,
      "username": "email-2@example.com"
    }
  }
```

### Delete

`DELETE /api/v1/players/:id`

**Headers:**

`Authorization: your-token`
