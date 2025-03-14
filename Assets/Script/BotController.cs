using UnityEngine;
using UnityEngine.Tilemaps;
using System.Collections.Generic;

public class BotController : MonoBehaviour
{
	/*// Tham chiếu tới các component có sẵn trên bot
	private MovementController moveCtrl;
	private BombController bombCtrl;
	private Rigidbody2D rb;

	// Trạng thái/biến hỗ trợ
	private Vector2 currentDirection = Vector2.zero;  // Hướng đang di chuyển
	private Vector2 targetPosition;                   // Mục tiêu hiện tại (nếu có)

	void Start()
	{
		moveCtrl = GetComponent<MovementController>();
		bombCtrl = GetComponent<BombController>();
		rb = GetComponent<Rigidbody2D>();
		// Vô hiệu hóa điều khiển người chơi để bot tự điều khiển
		if (moveCtrl) moveCtrl.enabled = false;
	}

	void Update()
	{
		// 1. Kiểm tra tránh bom nguy hiểm
		Vector2 escapeDir;
		if (CheckBombDanger(out escapeDir))
		{
			// Né bom bằng cách di chuyển theo hướng escapeDir (vuông góc hoặc xa bom nhất)
			SetMovementDirection(escapeDir);
			return; // ưu tiên cao nhất: thoát nguy hiểm, bỏ qua hành vi khác
		}

		// 2. Kiểm tra item gần nhất
		GameObject item = FindClosestItem();
		if (item != null)
		{
			// Đặt mục tiêu di chuyển tới item
			targetPosition = item.transform.position;
			MoveTowards(targetPosition);
			// Có thể đặt return ở đây để bot tập trung nhặt item trước khi làm việc khác
			// return;
		}

		// 3. Kiểm tra đối thủ (người chơi)
		GameObject enemy = FindClosestEnemy();
		if (enemy != null)
		{
			// Tính toán nếu có thể tấn công đối thủ
			if (IsEnemyInBombRange(enemy))
			{
				// Nếu đối thủ đang trong tầm bom và không bị chặn -> đặt bom tấn công
				if (bombCtrl != null && bombCtrl.bombsRemaining > 0)
				{
					bombCtrl.TriggerBomb();
					// Sau khi đặt bom, tìm hướng an toàn để rút lui
					Vector2 runDir = GetSafeDirectionFrom(transform.position);
					if (runDir != Vector2.zero)
						SetMovementDirection(runDir);
				}
			}
			else
			{
				// Chưa trong tầm, tiếp cận đối thủ
				targetPosition = enemy.transform.position;
				MoveTowards(targetPosition);
			}
		}
		else
		{
			// 4. Không có mục tiêu cụ thể -> di chuyển ngẫu nhiên (tuần tra)
			Wander();
		}
	}

	void FixedUpdate()
	{
		// Thực hiện di chuyển vật lý dựa trên currentDirection
		if (rb != null)
		{
			Vector2 pos = rb.position;
			Vector2 translation = currentDirection * (moveCtrl ? moveCtrl.speed : 5f) * Time.fixedDeltaTime;
			rb.MovePosition(pos + translation);
		}
	}

	// Đặt hướng di chuyển cho bot và bật hoạt ảnh tương ứng
	void SetMovementDirection(Vector2 dir)
	{
		currentDirection = dir;
		if (moveCtrl == null) return;
		// Bật hoạt ảnh theo hướng dir
		if (dir == Vector2.zero)
		{
			// Dừng lại: đặt sprite hiện tại về idle (đứng yên)
			moveCtrl.spriteRenderUp.idle = true;
			moveCtrl.spriteRenderDown.idle = true;
			moveCtrl.spriteRenderLeft.idle = true;
			moveCtrl.spriteRenderRight.idle = true;
			// (Hoặc chỉ idle sprite hiện đang active nếu track được)
		}
		else if (dir == Vector2.up)
		{
			moveCtrl.spriteRenderUp.enabled = true;
			moveCtrl.spriteRenderDown.enabled = false;
			moveCtrl.spriteRenderLeft.enabled = false;
			moveCtrl.spriteRenderRight.enabled = false;
			moveCtrl.spriteRenderUp.idle = false;
		}
		else if (dir == Vector2.down)
		{
			moveCtrl.spriteRenderUp.enabled = false;
			moveCtrl.spriteRenderDown.enabled = true;
			moveCtrl.spriteRenderLeft.enabled = false;
			moveCtrl.spriteRenderRight.enabled = false;
			moveCtrl.spriteRenderDown.idle = false;
		}
		else if (dir == Vector2.left)
		{
			moveCtrl.spriteRenderUp.enabled = false;
			moveCtrl.spriteRenderDown.enabled = false;
			moveCtrl.spriteRenderLeft.enabled = true;
			moveCtrl.spriteRenderRight.enabled = false;
			moveCtrl.spriteRenderLeft.idle = false;
		}
		else if (dir == Vector2.right)
		{
			moveCtrl.spriteRenderUp.enabled = false;
			moveCtrl.spriteRenderDown.enabled = false;
			moveCtrl.spriteRenderLeft.enabled = false;
			moveCtrl.spriteRenderRight.enabled = true;
			moveCtrl.spriteRenderRight.idle = false;
		}
	}

	// Di chuyển bot tiến về một vị trí mục tiêu (từng bước một)
	void MoveTowards(Vector2 targetPos)
	{
		// Tính vector hướng từ bot tới mục tiêu
		Vector2 directionToTarget = targetPos - (Vector2)transform.position;
		// Xác định hướng trục chính (lên/xuống hoặc trái/phải) nào gần mục tiêu nhất
		Vector2 moveDir = Vector2.zero;
		if (Mathf.Abs(directionToTarget.x) > Mathf.Abs(directionToTarget.y))
		{
			// Ưu tiên di chuyển theo trục X
			moveDir = (directionToTarget.x > 0) ? Vector2.right : Vector2.left;
		}
		else
		{
			// Ưu tiên di chuyển theo trục Y
			moveDir = (directionToTarget.y > 0) ? Vector2.up : Vector2.down;
		}
		// Kiểm tra nếu hướng đó bị chặn bởi vật cản, nếu có thì thử hướng khác
		if (IsObstacleAhead(moveDir))
		{
			// Nếu hướng chính bị chặn, thử hướng phụ (theo trục còn lại)
			if (moveDir == Vector2.left || moveDir == Vector2.right)
				moveDir = (directionToTarget.y > 0) ? Vector2.up : Vector2.down;
			else
				moveDir = (directionToTarget.x > 0) ? Vector2.right : Vector2.left;
			// Nếu hướng phụ cũng bị chặn, bot có thể đứng yên hoặc thử hướng khác tùy logic
			if (IsObstacleAhead(moveDir))
			{
				moveDir = Vector2.zero; // không thể tiến tới trực tiếp
			}
		}
		// Thực thi di chuyển theo hướng đã quyết định
		SetMovementDirection(moveDir);
	}

	// Xác định bot có đang trong tầm nổ của bom nào không. Trả về true và hướng thoát thân.
	bool CheckBombDanger(out Vector2 escapeDirection)
	{
		escapeDirection = Vector2.zero;
		// Tìm tất cả các bom đang tồn tại trong scene
		GameObject[] bombs = GameObject.FindGameObjectsWithTag("Bomb");
		// (Đảm bảo bomPrefab có tag "Bomb")
		foreach (GameObject bomb in bombs)
		{
			// Tính khoảng cách theo ô giữa bot và bom
			Vector2 bombPos = bomb.transform.position;
			float distX = Mathf.Abs(bombPos.x - transform.position.x);
			float distY = Mathf.Abs(bombPos.y - transform.position.y);
			// Kiểm tra cùng hàng hoặc cột trong phạm vi nổ
			int bombRange = bombCtrl.explosionRadius; // giả định các bot có cùng bán kính (hoặc có thể khác nếu biết)
			bool sameRow = distY < 0.5f && distX <= bombRange;    // cùng hàng, khoảng cách <= tầm nổ
			bool sameCol = distX < 0.5f && distY <= bombRange;    // cùng cột, khoảng cách <= tầm nổ
			if (sameRow || sameCol)
			{
				// Kiểm tra có tường chặn giữa bot và bom không (nếu có, không nguy hiểm trực tiếp)
				if (IsLineBlocked(transform.position, bombPos))
					continue;  // có chướng ngại giữa, nên không bị ảnh hưởng bom này
							   // Nếu không bị chặn: bot đang trong vùng nguy hiểm
							   // Xác định hướng thoát: chạy vuông góc ra khỏi hàng/cột của bom
				if (sameRow)
				{
					// bom cùng hàng -> chạy lên hoặc xuống (chọn hướng nào không bị chặn)
					Vector2 dir1 = Vector2.up;
					Vector2 dir2 = Vector2.down;
					escapeDirection = IsObstacleAhead(dir1) ? dir2 : dir1;
				}
				else if (sameCol)
				{
					// bom cùng cột -> chạy trái hoặc phải
					Vector2 dir1 = Vector2.left;
					Vector2 dir2 = Vector2.right;
					escapeDirection = IsObstacleAhead(dir1) ? dir2 : dir1;
				}
				return true;
			}
		}
		return false;
	}

	// Kiểm tra xem đường thẳng giữa hai vị trí (theo ô lưới) có bị chặn bởi tường/khối không
	bool IsLineBlocked(Vector2 startPos, Vector2 endPos)
	{
		// Nếu hai vị trí không thẳng hàng hoặc thẳng cột thì không áp dụng hàm này
		bool sameRow = Mathf.Abs(startPos.y - endPos.y) < 0.5f;
		bool sameCol = Mathf.Abs(startPos.x - endPos.x) < 0.5f;
		if (!sameRow && !sameCol) return true;
		// Tính hướng bước và số bước
		Vector2 step = sameRow ?
					   new Vector2(Mathf.Sign(endPos.x - startPos.x), 0) :
					   new Vector2(0, Mathf.Sign(endPos.y - startPos.y));
		int steps = (int)(sameRow ? Mathf.Abs(endPos.x - startPos.x) : Mathf.Abs(endPos.y - startPos.y));
		// Duyệt từng ô giữa start và end
		Vector2 checkPos = startPos;
		for (int i = 1; i < steps; i++)
		{
			checkPos += step;
			// Dùng Physics2D hoặc tilemap để kiểm tra ô này có vật cản không
			if (IsObstacleAt(checkPos))
				return true; // có chặn
		}
		return false; // không gặp chướng ngại nào giữa đường
	}

	// Kiểm tra có vật cản (tường, khối, bom) tại vị trí ô lưới nhất định
	bool IsObstacleAt(Vector2 gridPosition)
	{
		// Sử dụng OverlapBox kích thước 0.5 (nửa ô) để kiểm tra collider 
		Collider2D hit = Physics2D.OverlapBox(gridPosition, Vector2.one * 0.5f, 0f, bombCtrl.explosionLayerMask);
		if (hit != null) return true;
		// Cũng nên kiểm tra bom:
		Collider2D bombHit = Physics2D.OverlapBox(gridPosition, Vector2.one * 0.5f, 0f, LayerMask.GetMask("Bomb"));
		if (bombHit != null) return true;
		return false;
	}

	// Kiểm tra phía trước bot (hướng dir) có vật cản không
	bool IsObstacleAhead(Vector2 dir)
	{
		if (dir == Vector2.zero) return false;
		Vector2 nextPos = (Vector2)transform.position + dir;
		return IsObstacleAt(nextPos);
	}

	// Tìm item gần nhất (trả về GameObject item hoặc null nếu không có)
	GameObject FindClosestItem()
	{
		GameObject closest = null;
		float minDist = Mathf.Infinity;
		foreach (ItemPickup item in FindObjectsOfType<ItemPickup>())
		{
			float d = Vector2.Distance(transform.position, item.transform.position);
			if (d < minDist)
			{
				minDist = d;
				closest = item.gameObject;
			}
		}
		return closest;
	}

	// Tìm đối thủ gần nhất (trong các người chơi)
	GameObject FindClosestEnemy()
	{
		GameObject closest = null;
		float minDist = Mathf.Infinity;
		// Giả sử tất cả nhân vật (người chơi + bot) đều có tag "Player"
		GameObject[] players = GameObject.FindGameObjectsWithTag("Player");
		foreach (GameObject p in players)
		{
			if (p == this.gameObject || !p.activeSelf) continue; // bỏ qua bản thân bot và người chết
			float d = Vector2.Distance(transform.position, p.transform.position);
			if (d < minDist)
			{
				minDist = d;
				closest = p;
			}
		}
		return closest;
	}

	// Kiểm tra xem đối thủ có đứng trong tầm bom của bot không (cùng hàng/cột và không bị chặn)
	bool IsEnemyInBombRange(GameObject enemy)
	{
		if (enemy == null) return false;
		// khoảng cách theo ô
		Vector2 enemyPos = enemy.transform.position;
		float distX = Mathf.Abs(enemyPos.x - transform.position.x);
		float distY = Mathf.Abs(enemyPos.y - transform.position.y);
		int range = bombCtrl.explosionRadius;
		bool sameRow = distY < 0.5f && distX <= range;
		bool sameCol = distX < 0.5f && distY <= range;
		if ((sameRow || sameCol) && !IsLineBlocked(transform.position, enemyPos))
		{
			return true;
		}
		return false;
	}

	// Tìm một hướng an toàn (không có bom nổ tới) từ vị trí hiện tại của bot để di chuyển sau khi đặt bom
	Vector2 GetSafeDirectionFrom(Vector2 startPos)
	{
		// Kiểm tra bốn hướng xem hướng nào không nằm trong tầm nổ của bom nào
		Vector2[] dirs = new Vector2[] { Vector2.up, Vector2.down, Vector2.left, Vector2.right };
		foreach (Vector2 dir in dirs)
		{
			if (!IsObstacleAt(startPos + dir))
			{
				// giả sử bước 1 ô là đủ an toàn, hoặc có thể kiểm tra kỹ bom nào có thể nổ vào ô này
				// Ở đây ta đơn giản chọn hướng nào trống là chạy
				return dir;
			}
		}
		return Vector2.zero;
	}

	// Di chuyển ngẫu nhiên khi không có mục tiêu (đơn giản: đổi hướng khi gặp cản)
	void Wander()
	{
		if (currentDirection == Vector2.zero || IsObstacleAhead(currentDirection))
		{
			// Chọn hướng mới ngẫu nhiên trong 4 hướng
			Vector2[] dirs = new Vector2[] { Vector2.up, Vector2.down, Vector2.left, Vector2.right };
			Vector2 newDir = dirs[Random.Range(0, dirs.Length)];
			// Nếu hướng chọn đang bị cản, thử hướng khác
			int attempts = 0;
			while (IsObstacleAhead(newDir) && attempts < dirs.Length)
			{
				newDir = dirs[Random.Range(0, dirs.Length)];
				attempts++;
			}
			SetMovementDirection(newDir);
		}
		// nếu currentDirection không bị cản thì bot cứ tiếp tục đi theo hướng đó (cho tới khi nào bị cản sẽ chọn hướng khác)
	}*/

	public float speed = 3f;
	public Vector2 direction = Vector2.right;
	public LayerMask obstacleLayer;

	[Header("Animation Sprite Renders")]
	public AnimationSpritesRender spriteRenderUp;
	public AnimationSpritesRender spriteRenderDown;
	public AnimationSpritesRender spriteRenderLeft;
	public AnimationSpritesRender spriteRenderRight;

	private Rigidbody2D rb;
	private AnimationSpritesRender activeSprite;

	void Start()
	{
		rb = GetComponent<Rigidbody2D>();
		direction = direction.normalized;
		SetAnimationDirection(direction);
	}

	void FixedUpdate()
	{
		Vector2 position = rb.position;
		Vector2 movement = direction * speed * Time.fixedDeltaTime;
		rb.MovePosition(position + movement);
	}

	private void OnCollisionEnter2D(Collision2D collision)
	{
		if ((obstacleLayer.value & (1 << collision.gameObject.layer)) != 0)
		{
			direction = -direction;
			SetAnimationDirection(direction);
		}
	}

	private void SetAnimationDirection(Vector2 dir)
	{
		// Vô hiệu hóa tất cả sprite render trước
		spriteRenderUp.enabled = false;
		spriteRenderDown.enabled = false;
		spriteRenderLeft.enabled = false;
		spriteRenderRight.enabled = false;

		if (Mathf.Abs(dir.x) > Mathf.Abs(dir.y))
		{
			// Di chuyển ngang
			if (dir.x > 0)
				activeSprite = spriteRenderRight;
			else
				activeSprite = spriteRenderLeft;
		}
		else
		{
			// Di chuyển dọc
			if (dir.y > 0)
				activeSprite = spriteRenderUp;
			else
				activeSprite = spriteRenderDown;
		}

		activeSprite.enabled = true;
		activeSprite.idle = false;
	}
}


