import { MdFileDownload, MdImage } from 'react-icons/md';
import PropTypes from 'prop-types';

export default function Result({ image }) {
  return (
    <div id='result' style={image ? { backgroundImage: `url(${image})` } : {}}>
      {!image && (
        <div className='placeholder'>
          <MdImage size={48} style={{ marginBottom: '1rem', opacity: 0.5 }} />
          <p>Your enhanced image will appear here</p>
        </div>
      )}
      {image && (
        <a
          href={image}
          download
          className='download'
          title='Download enhanced image'
        >
          <MdFileDownload size={24} />
        </a>
      )}
    </div>
  );
}

Result.propTypes = {
  image: PropTypes.string,
};
