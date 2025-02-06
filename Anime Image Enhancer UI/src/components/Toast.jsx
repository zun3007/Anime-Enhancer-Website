import { MdCheckCircle, MdError } from 'react-icons/md';
import PropTypes from 'prop-types';

export default function Toast({ message, status }) {
  return (
    <div id='toast' className={status}>
      {status === 'success' ? (
        <MdCheckCircle size={20} style={{ marginRight: '0.5rem' }} />
      ) : (
        <MdError size={20} style={{ marginRight: '0.5rem' }} />
      )}
      <span>{message}</span>
    </div>
  );
}

Toast.propTypes = {
  message: PropTypes.string.isRequired,
  status: PropTypes.oneOf(['success', 'fail']).isRequired,
};
