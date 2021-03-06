function [ predictx, predicty, state, param ] = kalmanFilter( t, x, y, state, param, previous_t )
%UNTITLED Summary of this function goes here
%   Four dimensional state: position_x, position_y, velocity_x, velocity_y

    %% Place parameters like covarainces, etc. here:
    dt = t - previous_t;
    
    F = [1 0 dt 0;
         0 1 0 dt;
         0 0 1 0;
         0 0 0 1];
    Q = 0.01 * eye(4);
    H = [1 0 0 0;
         0 1 0 0];
    R = 0.005 * eye(2);

    % Check if the first time running this function 
    if previous_t<0
        state = [x, y, 0, 0];
        predictx = x;
        predicty = y;
        param.P = 10 * eye(4);
        return;
    end

    state = state.';
    state =  F * state;
    P = F * param.P * F.' + Q;
    
    y = [x;y] - H * state;
    S = H * P * H.' + R;
    K = P * H.' / S;
    state = state + K * y;
    P = (eye(4) - K * H) * P;
    
    param.P = P;
    
    state = state.';
    
    predictx = state(1) + 0.33 * state(3);
    predicty = state(2) + 0.33 * state(4);
end
