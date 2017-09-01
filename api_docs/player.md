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
  "user_id": 3,
  "game_id": 5
}
```

**Example Response:**

```json
{
  "id": 1,
  "user_id": 3,
  "game_id": 5
}
```
