using Godot;
using System.Collections.Generic;

public partial class CurveGradientThing : Node2D
{
	[Export] private float pixelsPerMeter = 100;
	[Export] private float smoothingRadius = 1.0f;
	[Export] private int particleCount = 200;
	[Export] private float mass = 1.0f;
	[Export] private float targetDensity = 1.0f;
	[Export] private float pressureMultiplier = 1.0f;

	private List<Particle> particles = new List<Particle>();
	private float smoothingRadiusSquared = 0.0f;
	private float scaledDisplayWidth = 0;
	private float scaledDisplayHeight = 0;
	
    public override void _Ready()
    {
		smoothingRadius /= pixelsPerMeter;
		smoothingRadiusSquared = smoothingRadius*smoothingRadius;

		RandomNumberGenerator rng = new RandomNumberGenerator();
		rng.Randomize();

		int displayWidth = (int)ProjectSettings.GetSetting(
				"display/window/size/viewport_width"
		);
		int displayHeight = (int)ProjectSettings.GetSetting(
				"display/window/size/viewport_height"
		);

		scaledDisplayWidth = displayWidth / pixelsPerMeter;
		scaledDisplayHeight = displayWidth / pixelsPerMeter;

		for (int i = 0; i < particleCount; i++)
		{
			particles.Add(new Particle(
				new Vector2(
					rng.RandiRange(0, displayWidth) / pixelsPerMeter,
					rng.RandiRange(0, displayHeight) / pixelsPerMeter
				)
			));
		}
    }

	public override void _Process(double delta)
	{
		CalculateDensities();
		CalculatePressures();

		for (int i = 0; i < particleCount; i++) 
		{
			Particle particle = particles[i];

			particle.Velocity = particle.Pressure;
			particle.Position += particle.Velocity * (float)delta;

			if (particle.Position.X < 0) 
			{
				particle.Position.X = 0;
				particle.Velocity.X *= -1;
			} else if (particle.Position.X > scaledDisplayWidth)
			{
				particle.Position.X = scaledDisplayWidth;
				particle.Velocity.X *= -1;
			}

			if (particle.Position.Y < 0) 
			{
				particle.Position.Y = 0;
				particle.Velocity.Y *= -1;
			} else if (particle.Position.Y > scaledDisplayHeight)
			{
				particle.Position.Y = scaledDisplayHeight;
				particle.Velocity.Y *= -1;
			}

			particles[i] = particle;
		}

		QueueRedraw();
	}

	public override void _Draw()
	{
		foreach (Particle particle in particles)
		{
			DrawCircle(particle.Position * pixelsPerMeter, 5.0f, Colors.CornflowerBlue);	
			// DrawLine(particle.Position * pixelsPerMeter, (particle.Position + particle.Pressure) * pixelsPerMeter, Colors.Blue, 2);
			// DrawCircle((particle.Position + particle.Pressure) * pixelsPerMeter, 5.0f, Colors.Blue);
			// DrawCircle(particle.Position * pixelsPerMeter, smoothingRadius * pixelsPerMeter, Colors.Red, false);
		}
	}

	private void CalculateDensities()
	{
		for (int i = 0; i < particleCount; i++)
		{
			Particle particle = particles[i];
			particle.Density = CalculateDensity(particle.Position);
			particles[i] = particle;
		}
	}

	private float PressureFromDensity(float density) 
	{
		float error = targetDensity - density;
		error *= pressureMultiplier;
		return error;
	}

	private void CalculatePressures()
	{
		for (int i = 0; i < particleCount; i++)
		{
			Particle particle = particles[i];
			particle.Pressure = CalculatePressure(particle.Position);
			particles[i] = particle;
		}
	}

	private float CalculateDensity(Vector2 position)
	{
		float density = 0.0f;
		foreach (Particle particle in particles)
		{
			float distanceSquared = particle.Position.DistanceSquaredTo(position);
			density += Poly6Kernel(distanceSquared) * mass;
		}
		return density;
	}

	private Vector2 CalculatePressure(Vector2 position)
	{
		Vector2 pressure = Vector2.Zero;

		foreach (Particle particle in particles)
		{
			float distance = particle.Position.DistanceTo(position);
			Vector2 direction = particle.Position.DirectionTo(position);

			float slope = SpikyKernelDerivative(distance);
			pressure += (direction * mass * slope * PressureFromDensity(particle.Density)) / particle.Density;
		}

		return pressure;
	}

	private float Poly6Kernel(float distanceSquared)
	{
		if (distanceSquared > smoothingRadiusSquared)
		{
			return 0.0f;
		}

		float factor = Mathf.Pow(smoothingRadiusSquared - distanceSquared, 3);
		float coefficient = 315 / (64*Mathf.Pi*Mathf.Pow(smoothingRadius, 9));
		return coefficient*factor;
	}

	private float SpikyKernelDerivative(float distance)
	{
		if (distance > smoothingRadius)
		{
			return 0.0f;
		}

		float factor = Mathf.Pow(smoothingRadius - distance, 3);
		float coefficient = -45 / (Mathf.Pi*Mathf.Pow(smoothingRadius, 6));
		return factor*coefficient;
	}

	public struct Particle 
	{
		public Vector2 Position;
		public Vector2 Velocity;
		public float Density;
		public Vector2 Pressure;

		public Particle(Vector2 position)
		{
			this.Position = position;
			this.Velocity = Vector2.Zero;
			this.Density = 0.0f;
			this.Pressure = Vector2.Zero;
		}
	}
}
