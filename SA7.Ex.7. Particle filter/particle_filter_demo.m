% Number of particles
numParticles = 1000;

% Initialize particles and weights
particles = rand(numParticles, 2); % Assuming 2D state space
weights = ones(numParticles, 1) / numParticles;

% Define motion and measurement models
motionModel = @(x) x + randn(size(x)) * 0.1; % Example motion model
measurementModel = @(x, z) exp(-sum((x - z).^2, 2)); % Example measurement model

% Simulate a measurement
measurement = [0.5, 0.5];

for t = 1:100
    % Prediction step
    particles = motionModel(particles);
    
    % Update step
    weights = measurementModel(particles, measurement);
    weights = weights / sum(weights); % Normalize weights
    
    % Resampling step
    indices = randsample(1:numParticles, numParticles, true, weights);
    particles = particles(indices, :);
    weights = ones(numParticles, 1) / numParticles;
    
    % Plot particles
    scatter(particles(:,1), particles(:,2), 10, weights, 'filled');
    pause(0.1);
end