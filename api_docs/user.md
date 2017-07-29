# User

### Creating a User

`POST /users/`

**Headers:**

`Content-Type: application/json`

**Parameters:**

|**Name**|**Required**|**Description**|
| -------- | ---------- | ------------- |
| username | Yes        | Username. Must be unique |
| email    | Yes        | Email. Must be unique |
| password | Yes        | Password. Must be more than 8 characters long |

**Example request:**

```json
{
	"username": "thedude",
	"email": "dude@dude.dude",
	"password": "iamthedude"
}
```

**Example response:**

```json
{
    "id": 1,
    "email": "dude@dude.dude",
    "username": "thedude"
}
```

### Logging in

When a user logs in, the response will include a JSON Web Token (JWT) that can be used to make requests. It will also be available in the `authorization` header, alongside an `x-expires` header, which gives the expiration date.

`POST /users/login/`

**Headers**:

`Content-Type: application/json`

**Parameters:**

|**Name**|**Required**|
| -------- | ---------- |
| username | Yes        |
| password | Yes        |

**Example request:**

```json
{
	"username": "thedude",
	"password": "iamthedude"
}
```

**Example response:**

```json
{
    "user": {
        "id": 1,
        "email": "dude@dude.dude",
	"username": "thedude"
    },
    "jwt": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjEiLCJleHAiOjE1MDEwMzY5OTUsImlhdCI6MTUwMDk1MDU5NSwiaXNzIjoiQVBJIiwianRpIjoiZWIxYWIzYmItMDZhNi00MjI5LWI1ZDUtZTUxM2JlMTJlYTU0IiwicGVtIjp7fSwic3ViIjoiVXNlcjoxIiwidHlwIjoiYWNjZXNzIn0.AvyI2nd9YjGRydRgsGpg6sdGeu3FA373rvef6HU7z0bMXhua6B06OedPYmLFcwiQZG2PioJ_dsq7eSCpFnHAtQ"
}
```

### Refreshing a token

`POST /users/refresh/`

**Headers:**

`Authorization: your-jwt`

**Parameters:**
None

**Example response:**
```json
{
    "jwt": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjEiLCJleHAiOjE1MDEwMzc1NzYsImlhdCI6MTUwMDk1MTE3NiwiaXNzIjoiQVBJIiwianRpIjoiMGIxMGJkZjYtYmE0NC00M2I3LWE2YzQtZTYwMWFmNzIzZWVmIiwibmJmIjoxNTAwOTUxMTc1LCJwZW0iOnt9LCJzdWIiOiJVc2VyOjEiLCJ0eXAiOiJhY2Nlc3MifQ.PJe85H6XL0bZKo12VkpMkjuibP_K4jsEnl0y7JIjgwC4y5Ce8UI8yW2jy5D90vYbp6xm6h9C30PI8nf7dSrrJQ"
}
```
