% Define your motion model
motionModel = @(x) x + randn(size(x)) * 0.1; % Example motion model

% Define the process noise covariance matrix
Q = [0.01, 0; 0, 0.01]; % Example covariance matrix

% Number of particles
numParticles = 1000;

% Initialize particles and weights
particles = rand(numParticles, 2); % Assuming 2D state space
weights = ones(numParticles, 1) / numParticles;

% Define your measurement model h(x)
h = @(x) [x(:,1) + x(:,2), x(:,1) - x(:,2)]; % Example measurement model

% Define the measurement noise covariance matrix
R = [0.1, 0; 0, 0.1]; % Example covariance matrix

% Simulate a measurement
measurement = [0.5, 0.5];

for t = 1:100
    % Prediction step
    particles = motionModel(particles);
    particles = particles + mvnrnd([0, 0], Q, numParticles); % Add process noise
    
    % Update step
    expectedMeasurements = h(particles); % Get expected measurements from the model
    measurementErrors = expectedMeasurements - measurement; % Calculate errors
    
    % Calculate the likelihoods considering measurement uncertainty
    weights = exp(-0.5 * sum((measurementErrors / R) .* measurementErrors, 2));
    weights = weights / sum(weights); % Normalize weights
    
    % Resampling step
    indices = randsample(1:numParticles, numParticles, true, weights);
    particles = particles(indices, :);
    weights = ones(numParticles, 1) / numParticles;
    
    % Plot particles
    scatter(particles(:,1), particles(:,2), 10, weights, 'filled');
    pause(0.1);
end