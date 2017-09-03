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
    "user": {
      "email": "email-3@example.com",
      "id": 728,
      "username": "email-3@example.com"
    }
  }
]
```
