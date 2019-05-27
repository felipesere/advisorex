import $ from 'cash-dom';

import { request } from './request';
import { storage } from './temporaryStorage';
import { image } from './dashboardImage';
import { modal } from './dashboardModal';

$(document).ready(() => {
  request.bind();
  storage.bind('.advice-question textarea');
  image.from('.js_user-image-input').to('js_user-image-display');
  modal.bind('.delete');
})
