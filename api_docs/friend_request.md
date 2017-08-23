# FriendRequest

### Create

`POST /v1/friend-requests/`

**Headers:**

`Content-Type: application/json` <br />
`Authorization: your-token`

**Parameters:**

|**Name**|**Type**|**Required**|**Description**|
| ------------ |-------- | ---------- | ------------- |
| requested_user_id       | integer  | Yes        | The id of the user being requested for friendship |

**Example Request:**

```json
{
  "requested_user_id": 1
}
```

**Example Response:**

```json
{
  "id": 10
}
```
