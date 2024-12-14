using Godot;
using System;

public partial class Player : CharacterBody3D
{
	public const float Speed = 5.0f;
	public const float JumpVelocity = 4.5f;
	public float gravity = ProjectSettings.GetSetting("physics/3d/default_gravity").AsSingle();

	public Node3D head;
	public Camera3D camera;
	public SpotLight3D light;

	public override void _Ready()
	{
		Input.MouseMode = Input.MouseModeEnum.Captured;
		head = GetNode<Node3D>("Head");
		camera = GetNode<Camera3D>("Head/Camera3D");
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion)
		{
			InputEventMouseMotion ev = (InputEventMouseMotion)@event;

			head.Transform = new Transform3D(
				head.Transform.Basis.Rotated(
						Vector3.Up,
						-ev.Relative.X * 0.01f
					),
					head.Transform.Origin
			);

			camera.Transform = new Transform3D(
				camera.Transform.Basis.Rotated(
					camera.Transform.Basis.X,
					-ev.Relative.Y * 0.01f
				),
				camera.Transform.Origin
			);

			float minX = Mathf.DegToRad(-40);
			float maxX = Mathf.DegToRad(60);
			camera.Rotation = new Vector3(
				Mathf.Clamp(
					camera.Rotation.X,
					minX,
					maxX
				),
				camera.Rotation.Y,
				0
			);
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		//if (!IsOnFloor())
			//velocity.Y -= gravity * (float)delta;

		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JumpVelocity;

		// if (Input.IsActionJustPressed("toggle_light") && IsOnFloor())
		//	light.

		Vector2 inputDir = Input.GetVector("left", "right", "up", "down");
		Vector3 direction = (head.Transform.Basis * new Vector3(inputDir.X, 0, inputDir.Y)).Normalized();

		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = 0;
			velocity.Z = 0;
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
