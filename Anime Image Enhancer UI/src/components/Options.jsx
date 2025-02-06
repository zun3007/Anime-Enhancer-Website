import { useState } from 'react';
import { MdCloudUpload } from 'react-icons/md';
import PropTypes from 'prop-types';

export default function Options({ showToast, handleSubmitForm, isLoading }) {
  const [model, setModel] = useState('x2');
  const [useGPU, setUseGPU] = useState(false);
  const [useCPUeGPU, setUseCPUeGPU] = useState(false);
  const [file, setFile] = useState(null);
  const [fileName, setFileName] = useState('');

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    if (selectedFile) {
      const validTypes = ['image/jpeg', 'image/png', 'image/jpg'];
      if (!validTypes.includes(selectedFile.type)) {
        showToast(
          'Please select a valid image file (JPEG, PNG, or JPG)',
          'fail',
          3000
        );
        e.target.value = '';
        return;
      }
      setFile(selectedFile);
      setFileName(selectedFile.name);
      showToast('File uploaded successfully!', 'success', 3000);
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!file) {
      showToast('Please select an image first', 'fail', 3000);
      return;
    }

    handleSubmitForm(model, useGPU, useCPUeGPU, file);
  };

  return (
    <div id='option'>
      <h2 className='option-header'>Enhancement Options</h2>
      <form className='option-form' onSubmit={handleSubmit}>
        <div>
          <label htmlFor='model'>Upscaling Model</label>
          <select
            id='model'
            value={model}
            onChange={(e) => setModel(e.target.value)}
          >
            <option value='x2'>2x Upscale</option>
            <option value='x3'>3x Upscale</option>
          </select>
        </div>

        <div>
          <label htmlFor='file' className='file-input-label'>
            <div className='file-input-content'>
              <MdCloudUpload size={24} />
              <span>{fileName || 'Choose an image to enhance'}</span>
            </div>
            <input
              type='file'
              id='file'
              accept='.jpg,.jpeg,.png'
              onChange={handleFileChange}
              style={{ display: 'none' }}
            />
          </label>
        </div>

        <div className='checkbox-group'>
          <div>
            <input
              type='checkbox'
              id='useGPU'
              checked={useGPU}
              onChange={(e) => {
                setUseGPU(e.target.checked);
                if (e.target.checked) setUseCPUeGPU(false);
              }}
            />
            <label htmlFor='useGPU'>Use NVIDIA GPU (CUDA)</label>
          </div>

          <div>
            <input
              type='checkbox'
              id='useCPUeGPU'
              checked={useCPUeGPU}
              onChange={(e) => {
                setUseCPUeGPU(e.target.checked);
                if (e.target.checked) setUseGPU(false);
              }}
            />
            <label htmlFor='useCPUeGPU'>Use Intel eGPU or AMD (OpenCL)</label>
          </div>
        </div>

        <button
          type='submit'
          disabled={!file || isLoading}
          className={isLoading ? 'loading' : ''}
        >
          {isLoading ? (
            <div className='loading-spinner'>
              <div className='spinner'></div>
              <span>Enhancing...</span>
            </div>
          ) : (
            'Enhance Image'
          )}
        </button>
      </form>
    </div>
  );
}

Options.propTypes = {
  showToast: PropTypes.func.isRequired,
  handleSubmitForm: PropTypes.func.isRequired,
  isLoading: PropTypes.bool.isRequired,
};
