event = {'s11', 's12', 's21', 's22'};
% event = {'rA', 'rB', 'rC', 'rD'};
sid = '0003';
glm_folder = 'GLM1s10';
% glm_folder = 'GLM3';
rndc = true;

% 8 sets
% s11s22: 14; s11s21: 13; s12s22: 24; s21s12: 32
% AB: 12; CD: 34; AC: 13; BD: 24
 
svm_all(sid, glm_folder, 7, 5, event, 1, 3, rndc, [1]);
svm_all(sid, glm_folder, 7, 5, event, 1, 3, ~rndc, [1]);
svm_all(sid, glm_folder, 7, 5, event, 2, 4, rndc, [1]);
svm_all(sid, glm_folder, 7, 5, event, 2, 4, ~rndc, [1]);
% svm_all(sid, glm_folder, 7, 5, event, 1, 4, rndc, [1]);
% svm_all(sid, glm_folder, 7, 5, event, 1, 4, ~rndc, [1]);
% svm_all(sid, glm_folder, 7, 5, event, 3, 2, rndc, [1]);
% svm_all(sid, glm_folder, 7, 5, event, 3, 2, ~rndc, [1]);

